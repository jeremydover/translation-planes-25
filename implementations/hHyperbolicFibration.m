load "library/hyperbolic-fibration.m";

hHyperbolicFibrationImplementation:=function(q,reguli);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	if IsEven(q) then print "q must be odd"; return 0; end if;
	
	if #reguli ne q-1 or exists{x:x in reguli|x notin {0,1}} then print "reguli is not properly formatted."; return 0; end if;
	
	F:=GF(q);
	K<beta>:=ext<F|2>;
	mu:=Rep({x:x in F|not(IsSquare(x)) and not(IsSquare(1-4*x))});
	t0:=(q mod 4) eq 1 select F!1 else F!0;
	hypFib:=[<t,t,t*mu,1,1,mu>:t in F|t ne F!0 and not(IsSquare((t-t0)^2*(1-4*mu)-1))];
	
	alpha:=beta^((q-1) div 2);
	C1:=[alpha^i:i in [1..2*q+1 by 4]];
	epsilon:=beta^((q+1) div 2);
	omega:=F!(epsilon^2);
	flag,r:=IsSquare(omega/(1-4*mu));
	if not(flag) then print "This should not happen."; return 0; end if;
	V,phi:=VectorSpace(K,F,[1,epsilon]);
	
	for x in C1 do
		z0:=phi(x)[1];
		z1:=phi(x)[2];
		Append(~hypFib,<t0+z1*r,t0+z0+z1*r,t0*mu+1/2*z0+1/2*r*(1-2*mu)*z1,1,1,mu>);
	end for;
	
	Q:=enumeratePointsInQuadrics(hypFib);
	reg:=findReguliInQuadricSets(Q);
	if Type(reg) eq RngIntElt then return 0; end if;
	W:=Generic(Rep(reg[1][1]));
	sp:={sub<W|W![1,0,0,0],W![0,1,0,0]>,sub<W|W![0,0,1,0],W![0,0,0,1]>} join (&join [reg[i][reguli[i]+1]:i in [1..q-1]]);
	return buildTranslationPlane(sp);
end function;
	