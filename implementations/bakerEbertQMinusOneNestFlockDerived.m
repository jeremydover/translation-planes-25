load "implementations/bakerEbertQMinusOneNest.m";

bakerEbertQMinusOneNestFlockDerivedImplementation:=function(q,b,mu);
	lambdaSNest:=bakerEbertQMinusOneNest(q,b);
	if Type(lambdaSNest) eq RngIntElt then return 0; end if;
	
	phi:=buildFieldStructures(q,2);	
	/*The regulus to be reversed does contain infinity, so the lambda-S model does not work. So we build
	the spread. Note, however, that we have lost the connection between the spread and the field model, so we will have to recreate.*/
	sp:=buildConnectedNestSpread(phi,lambdaSNest);
	if Type(sp) eq RngIntElt then return 0; end if;
	
	/*Get the basic structures out, and test mu*/
	V:=Image(phi);
	K:=Domain(phi);
	F:=GF(q);
	M,chi:=VectorSpace(F,PrimeField(F));

	if Type(mu) eq RngIntElt then print "mu must be a sequence, even if only length 1."; return 0; end if;
	if #mu ne Degree(K) then print "The sequence for mu is the wrong length for this field."; return 0; end if;
	mu:=(V!mu)@@phi;	
	b:=(M!b)@@chi;
	disc:=F!(1/4*Trace(mu,F)^2-(Norm(mu,F)*(1+b)));
	if (disc eq 0) or not(IsSquare(disc)) then print "mu does not represent a regulus disjoint from the nest"; return 0; end if;
	muCircle:={x:x in K|mu*x^q eq -(mu^q)*x}; /*This circle also contains infinity*/
	
	regulusToReplace:=prepareRawCircleForRegulusReversal(phi,muCircle);
	psp:=removeRawCircleFromSpread(phi,sp,muCircle);
	
	oppreg:=findOppositeRegulus(regulusToReplace);
	nsp:=addRegulusReplacementToSpread(phi,psp,oppreg);
	return buildTranslationPlane(nsp);

end function;
