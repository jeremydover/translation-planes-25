load "library/bruck-bose.m";

heringQuasifieldImplementation:=function(q);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	if (q mod 6) ne 5 then print "q must be = 5(mod 6)"; return 0; end if;
		
	K<w>:=GF(q);
	W:=VectorSpace(GF(q),4);
	sp:={sub<W|W![0,0,1,0],W![0,0,0,1]>} join {sub<W|W![1,0,-3*b^2,-2*b^3],W![0,1,2*b,b^2]>:b in K} join
        {sub<W|W![1,0,-3*a^2*(b^2-1),-2*a^3*(b^3+3*b)],W![0,1,2*a*b,a^2*(b^2+3)]>:a,b in K|a ne 0} join     {sub<W|W![1,0,-3*a^2*(b^2+3),-2*a^3*(b^3+3*b)],W![0,1,2*a*b,a^2*(b^2-1)]>:a,b in K|a ne 0};

	Pi:=buildTranslationPlane(sp);
	return Pi;
end function;
