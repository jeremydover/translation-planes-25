load "implementations/bakerEbertQMinusOneNest.m";

bakerEbertQMinusOneNestCompanionDerivedImplementation:=function(q,b);
	lambdaSNest:=bakerEbertQMinusOneNest(q,b);
	if Type(lambdaSNest) eq RngIntElt then return 0; end if;
	
	phi:=buildFieldStructures(q,2);	
	sp:=buildConnectedNestSpread(phi,lambdaSNest);
	if Type(sp) eq RngIntElt then return 0; end if;
	
	K:=Domain(phi);
	V:=Image(phi);
	F:=GF(q);
	w:=PrimitiveElement(K);
	epsilon:=w^((q+1) div 2);
	M,chi:=VectorSpace(F,PrimeField(F));
	b:=(M!b)@@chi;
	
	muCircle:={x:x in K|x*(x^q+epsilon) eq (epsilon*x^q+epsilon^2*(1+b))};
	
	regulusToReplace:=prepareRawCircleForRegulusReversal(phi,muCircle);
	psp:=removeRawCircleFromSpread(phi,sp,muCircle);
	
	oppreg:=findOppositeRegulus(regulusToReplace);
	nsp:=addRegulusReplacementToSpread(phi,psp,oppreg);
	return buildTranslationPlane(nsp);

end function;
