load "library/bruck-bose.m";

subregular2dImplementation:=function(q,reguli);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	p:=PrimeDivisors(q)[1];
	
	if Type(reguli) ne SeqEnum then print "reguli must be a sequence of integers."; return 0; end if;
	if exists{x:x in reguli|x lt 0 or x ge p} then print "Every entry in reguli must be in the prime field of GF(q)."; return 0; end if;
	e:=Valuation(q,p);
	if (#reguli mod (4*e)) ne 0 then print "The regulus sequence must have length divisible by 4*e, where q=p^e for prime p"; return 0; end if;

	phi:=buildFieldStructures(q,2);
	sp:=makeRegularSpread(phi);
	lambdaSReguli:=convertReguliSerializedToLambdaS(phi,reguli);
	psp:=removeReguliFromRegularSpread(phi,sp,lambdaSReguli);
	nsp:=replaceReguliInRegularSpread(phi,psp,lambdaSReguli);
	Pi:=buildTranslationPlane(nsp);
	return Pi;
end function;
