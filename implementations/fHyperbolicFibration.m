load "library/hyperbolic-fibration.m";

fHyperbolicFibrationImplementation:=function(q,reguli);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	if IsEven(q) then print "q must be odd"; return 0; end if;
	
	if #reguli ne q-1 or exists{x:x in reguli|x notin {0,1}} then print "reguli is not properly formatted."; return 0; end if;
	
	F:=GF(q);
	mu:=Rep({x:x in F|not(IsSquare(x)) and not(IsSquare(1-4*x))});
	hypFib:=[<t,t+1,t*mu,1,1,mu>:t in F|t ne F!0 and not(IsSquare((t+1)^2-4*mu*t^2))];
	
	B:={b:b in F|IsSquare((1-4*mu)*b^2+8*mu*b) and not(IsSquare(2*b))};
	
	for b in B do
		flag,x:=IsSquare(4*b^2-16*mu*b*(b-2));
		c1:=(2*b+x)/8;
		c2:=(2*b-x)/8;
		Append(~hypFib,<c1/mu,b,c2,1,1,mu>);
		Append(~hypFib,<c2/mu,b,c1,1,1,mu>);
	end for;
	
	Q:=enumeratePointsInQuadrics(hypFib);
	reg:=findReguliInQuadricSets(Q);
	if Type(reg) eq RngIntElt then return 0; end if;
	W:=Generic(Rep(reg[1][1]));
	sp:={sub<W|W![1,0,0,0],W![0,1,0,0]>,sub<W|W![0,0,1,0],W![0,0,0,1]>} join (&join [reg[i][reguli[i]+1]:i in [1..q-1]]);
	return buildTranslationPlane(sp);
end function;
	