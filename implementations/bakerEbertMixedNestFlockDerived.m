load "implementations/bakerEbertMixedNest.m";

bakerEbertMixedNestFlockDerivedImplementation:=function(q,c,reguli);
	lambdaSNest:=bakerEbertMixedNest(q,c);
	if Type(lambdaSNest) eq RngIntElt then return 0; end if;
	if Type(reguli) ne SeqEnum then print "reguli must be a sequence."; return 0; end if;

	phi:=buildFieldStructures(q,2);
	K:=Domain(phi);
	F:=GF(q);
	M,chi:=VectorSpace(F,PrimeField(F));
	
	sp:=buildConnectedNestSpread(phi,lambdaSNest);
	if Type(sp) eq RngIntElt then return 0; end if;
	
	p:=PrimeDivisors(q)[1];
	if exists{x:x in reguli|x lt 0 or x ge p} then print "Every entry in reguli must be in the prime field of GF(q)."; return 0; end if;
	e:=Valuation(q,p);
	if (#reguli mod e) ne 0 then print "The regulus sequence must have length divisible by e, where q=p^e for prime p"; return 0; end if;
	
	vectors:=Partition(reguli,Dimension(M));
	c:=(M!c)@@chi;
	lambdaSReguli:={};
	for x in vectors do
		a:=(M!x)@@chi;
		if a eq F!0 or not(IsSquare((a*c-1)^2-4*a)) then print "a does not represent a regulus disjoint from the nest."; return 0; end if;
		lambda,s:=convertRegulusLambdaABToLambdaS(K!0,a,1);
		Include(~lambdaSReguli,<lambda,s>);
	end for;
	psp:=removeReguliFromRegularSpread(phi,sp,lambdaSReguli);
	nsp:=replaceReguliInRegularSpread(phi,psp,lambdaSReguli);
	if Type(nsp) eq RngIntElt then print "Regulus replacement failed."; return 0;
	else return buildTranslationPlane(nsp);
	end if;

end function;
