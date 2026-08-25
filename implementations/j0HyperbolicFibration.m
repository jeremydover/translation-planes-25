load "library/hyperbolic-fibration.m";

j0HyperbolicFibrationImplementation:=function(q,i,reguli);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	if IsEven(q) then print "q must be odd"; return 0; end if;
	F:=GF(q);
	p:=#PrimeField(F);
	e:=Valuation(q,p);
	if i lt 0 or i gt e then print "i must be between 0 and e, inclusive"; return 0; end if;
	
	if #reguli ne q-1 or exists{x:x in reguli|x notin {0,1}} then print "reguli is not properly formatted."; return 0; end if;
	w:=PrimitiveElement(F);
	hypFib:=[<t,0,-w*t^(p^i),1,0,-w>:t in F|t ne F!0];
	
	Q:=enumeratePointsInQuadrics(hypFib);
	reg:=findReguliInQuadricSets(Q);
	if Type(reg) eq RngIntElt then return 0; end if;
	W:=Generic(Rep(reg[1][1]));
	sp:={sub<W|W![1,0,0,0],W![0,1,0,0]>,sub<W|W![0,0,1,0],W![0,0,0,1]>} join (&join [reg[j][reguli[j]+1]:j in [1..q-1]]);
	return buildTranslationPlane(sp);
end function;
	