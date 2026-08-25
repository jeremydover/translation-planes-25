/*This library file contains functions needed to load and deal with reference model files. Note: most of the functions here involved pushing data around in various forms, not actual mathematics, so I prompted ChatGPT to write them.*/

extractJSONInteger:=function(line, key);
    token := "\"" cat key cat "\":";
    p := Index(line, token);

    if p eq 0 then
        return false, 0;
    end if;

    start := p + #token;
    rest := line[start..#line];

    // Find end of integer: comma or closing brace
    q := Index(rest, ",");
    r := Index(rest, "}");

    if q eq 0 then
        q := r;
    elif r ne 0 then
        q := Minimum(q, r);
    end if;

    if q eq 0 then
        return false, 0;
    end if;

    return true, StringToInteger(rest[1..q-1]);
end function;

extractJSONString:=function(line, key);
    token := "\"" cat key cat "\":\"";
    p := Index(line, token);

    if p eq 0 then
        return false, "";
    end if;

    start := p + #token;
    rest := line[start..#line];
    q := Index(rest, "\"");

    if q eq 0 then
        return false, "";
    end if;

    return true, rest[1..q-1];
end function;


loadReferenceModelIndex:=function(filename);
    __referenceModelIndex := AssociativeArray();
	f := Open(filename, "r");

    while true do
        line := Gets(f);

        if IsEof(line) then
            break;
        end if;

        if #line eq 0 then
            continue;
        end if;

        okId, id := extractJSONString(line, "id");
		okOrder, order := extractJSONInteger(line, "order");
        okRef, ref := extractJSONString(line, "referenceModel");

        if okId and okOrder and okRef then
            __referenceModelIndex[id] := <order,ref>;
        end if;
    end while;

    return __referenceModelIndex;
end function;

if not assigned __referenceModelIndex then
    __referenceModelIndex := loadReferenceModelIndex("planes.jsonl");
end if;

loadPackedProjectivePlane := function(id);
	q:=__referenceModelIndex[id][1];
	filename:=__referenceModelIndex[id][2];
	
	
	if q lt 2 then
        error "The plane order q must be at least 2";
    end if;

    v := q^2 + q + 1;
    k := q + 1;
    expectedBytes := 2 * v * k;

    data := ReadBinary(filename);

    if #data ne expectedBytes then
        error Sprintf(
            "Invalid packed plane file: expected %o bytes, found %o",
            expectedBytes,
            #data
        );
    end if;

    lines := [];
    pos := 1;

    for lineNumber in [1..v] do
        pointIds := [];

        for incidenceNumber in [1..k] do
            lowByte  := data[pos];
            highByte := data[pos + 1];
            pos +:= 2;

            pointId := lowByte + 256 * highByte;

            if pointId ge v then
                error Sprintf(
                    "Invalid point ID %o on line %o; expected an ID in [0..%o]",
                    pointId,
                    lineNumber,
                    v - 1
                );
            end if;

            Append(~pointIds, pointId);
        end for;

        // The packed format requires strictly increasing zero-based IDs.
        for i in [1..k - 1] do
            if pointIds[i] ge pointIds[i + 1] then
                error Sprintf(
                    "Point IDs on line %o are not strictly increasing: %o",
                    lineNumber,
                    pointIds
                );
            end if;
        end for;

        // Magma's integer plane constructor uses points 1,...,v.
        Append(~lines, { pointId + 1 : pointId in pointIds });
    end for;

    /*
        Check := true instructs Magma to verify that the supplied
        incidence structure satisfies the projective-plane axioms.
    */
    P, pointSet, lineSet :=
        FiniteProjectivePlane< v | lines : Check := true >;

    return P, pointSet, lineSet;
end function;
