load "library/bruck-bose.m";

fisherFlockNest:=function(q);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	if IsEven(q) then print "q must be odd"; return 0; end if;
	
	phi:=buildFieldStructures(q,2);
	K:=Domain(phi);
	F:=GF(q);
	w:=PrimitiveElement(K);
	epsilon:=w^((q+1) div 2);

	lambda:=epsilon;
	b:=1;
	a:=(q mod 4) eq 3 select epsilon^2-1 else 0;
	lambda,s:=convertRegulusLambdaABToLambdaS(lambda,a,b);
	return [<lambda+x*epsilon,s>:x in F];
end function;
	
fisherFlockImplementation:=function(q);
	lambdaSNest:=fisherFlockNest(q);
	if Type(lambdaSNest) eq RngIntElt then return 0; end if;
	
	phi:=buildFieldStructures(q,2);
	nsp:=buildConnectedNestSpread(phi,lambdaSNest);
	if Type(nsp) eq RngIntElt then return 0; end if;
	return buildTranslationPlane(nsp);
end function;
