load "library/hyperbolic-fibration.m";

j1HyperbolicFibrationImplementation:=function(q,reguli);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	if IsEven(q) then print "q must be odd"; return 0; end if;
	if (q mod 3) eq 1 then print "q may not be equivalent to 1 mod 3"; return 0; end if;

	F:=GF(q);
	w:=PrimitiveElement(F);
	if (q mod 3) eq 0 then
		hypFib:=[<t,0,-w*t^3,1,0,-w>:t in F|t ne F!0];
	else
		hypFib:=[<t,3*t^2,3*t^3,1,3,3>:t in F|t ne F!0];
	end if;
	
	if #reguli ne q-1 or exists{x:x in reguli|x notin {0,1}} then print "reguli is not properly formatted."; return 0; end if;
	
	Q:=enumeratePointsInQuadrics(hypFib);
	reg:=findReguliInQuadricSets(Q);
	if Type(reg) eq RngIntElt then return 0; end if;
	W:=Generic(Rep(reg[1][1]));
	sp:={sub<W|W![1,0,0,0],W![0,1,0,0]>,sub<W|W![0,0,1,0],W![0,0,0,1]>} join (&join [reg[i][reguli[i]+1]:i in [1..q-1]]);
	return buildTranslationPlane(sp);
end function;
	