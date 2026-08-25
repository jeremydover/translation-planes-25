load "library/bruck-bose.m";

/* This file contains a number of functions that allow the user to work with and construct planes from hyperbolic fibrations. Our representation assumes that each quadric can be described via the sextuplet [a,b,c,d,e,f] of elements in GF(q), such that the quadric is V(ax_0^2+bx_0x_1+cx_1^2+dx_2^2+ex_2x_3+fx_3^2), and that the two lines outside the hyperbolic fibrations are <x_0,x_1,0,0> and <0,0,x_2,x_3>.*/

convertVectorRepToField:=function(q,hypFib);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	F:=GF(q);
	p:=#PrimeField(F);
	U,chi:=VectorSpace(F,PrimeField(F));
	
	if Type(hypFib) ne SeqEnum or exists{x:x in hypFib|x lt 0 or x ge p} then print "Every entry in hypFib must be in the prime field of GF(q)."; return 0; end if;
	e:=Valuation(q,p);
	
	if #hypFib ne 6*e*(q-1) then print "The hypFib sequence must have length 6e(q-1), where q=p^e for prime p"; return 0; end if;
	
	hSeq:=[];
	quadrics:=Partition(hypFib,6*e);
	for Q in quadrics do
		coeffs:=Partition(Q,e);
		Append(~hSeq,[(U!coeffs[i])@@chi:i in {1..#coeffs}]);
	end for;
	return hSeq;
end function;
		
enumeratePointsInQuadrics:=function(H);
	F:=Parent(H[1][1]);
	V:=VectorSpace(F,4);
	Vstar:=Set(V) diff {V!0};
	Vstar diff:= {V![a,b,0,0]:a,b in F};
	Vstar diff:= {V![0,0,a,b]:a,b in F};
	quads:=[{V!0}:i in {1..#F-1}];
	for v in Vstar do
		for j in {1..#H} do
			if (H[j][1]*v[1]^2+H[j][2]*v[1]*v[2]+H[j][3]*v[2]^2+H[j][4]*v[3]^2+H[j][5]*v[3]*v[4]+H[j][6]*v[4]^2) eq 0 then
				Include(~quads[j],v);
				break;
			end if;
		end for;
	end for;
	for i in {1..#quads} do
		Exclude(~quads[i],V!0);
	end for;
	return quads;
end function;

findReguliInQuadricSets:=function(Q);
	V:=Parent(Rep(Q[1]));
	reguli:=[];
	for quad in Q do
		myQuadSeq:=Sort(SetToSequence(quad));
		v0:=myQuadSeq[1];
		firstLine:=0;
		for i in [2..#myQuadSeq] do
			VS0:=sub<V|v0,myQuadSeq[i]>;
			S0:=Set(VS0) diff {V!0};
			if Dimension(VS0) eq 2 and S0 subset quad then
				firstLine:=i;
				regulus:=[VS0];
				break;
			end if;
		end for;
		if firstLine eq 0 then print "Something went tragically wrong, maybe not a quadric?"; return 0; end if;
		
		quadPoints:=quad diff Set(Rep(regulus));
		while #quadPoints gt 0 do
			v:=Rep(quadPoints);
			foundLine:=0;
			for x in Exclude(quadPoints,v) do
				VS:=sub<V|v,x>;
				S:=Set(VS) diff {V!0};
				if Dimension(VS meet VS0) eq 0 and Dimension(VS) eq 2 and S subset quad then
					Append(~regulus,VS);
					quadPoints diff:= Set(VS);
					foundLine:=1;
					break;
				end if;
			end for;
			if foundLine eq 0 then print "Quadric is malformed. Failing."; return 0; end if;
		end while;
		
		oppRegulus:=findOppositeRegulus(regulus);
		Append(~reguli,<SequenceToSet(regulus),oppRegulus>);
	end for;
	return reguli;
end function;