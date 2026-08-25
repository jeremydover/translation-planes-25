load "library/bruck-bose.m";

bakerEbertFlagTransitiveImplementation:=function(q,s,r);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	if IsEven(q) then print "q must be odd for this construction"; return 0; end if;
	if IsEven(s) then print "s must be an odd integer"; return 0; end if;
	if (s lt 1) or (s gt q^2) then printf "s must be between 1 and %o, inclusive",q^2; print ""; return 0; end if;
		
	K:=GF(q);
	F<beta>:=ext<K|4>;
	V,phi:=VectorSpace(F,K);
	
	L:={F!1} join {beta^(s*(q+1))+a:a in K};
	Lorb:={{x*beta^(2*i*(q+1)):x in L}:i in {1..(q^2+1) div 2}};
	
	R:= {beta^r} join {beta^r*(beta^(s*q*(q+1))+a):a in K};
	Rorb:={{x*beta^(2*i*(q+1)):x in R}:i in {1..(q^2+1) div 2}};
	
	if #(&join(Lorb) meet &join(Rorb)) ne 0 then print "The chosen values of s and r do not determine a spread."; return 0; end if;
	
	sp:={sub<V|{phi(x):x in l}>:l in (Lorb join Rorb)};
	
	Pi:=buildTranslationPlane(sp);
	return Pi;
end function;
