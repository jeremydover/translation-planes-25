load "implementations/bakerEbertQMinusOneNest.m";

bakerEbertTwoQMinusOneNestImplementation:=function(q,b,color);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	if IsEven(q) then print "q must be odd"; return 0; end if;
	
	lambdaSNest1:=bakerEbertQMinusOneNest(q,b);
	if Type(lambdaSNest1) eq RngIntElt then return 0; end if;
	lambdaSNest2:=bakerEbertQMinusOneNest(q,b:alt:=true);
	if Type(lambdaSNest2) eq RngIntElt then return 0; end if;
	
	phi:=buildFieldStructures(q,2);
	nsp1:=buildConnectedNestSpread(phi,lambdaSNest1);	/*Note: the standard defaults to color 0*/
	if Type(nsp1) eq RngIntElt then return 0; end if;
	/* Note: we are abusing the base function a bit...nsp1 is NOT a regular spread. However, all of the lines to be removed for lambdaSNest2 are still in nsp1, and since the removal does not require the field model, just set inclusion, we should be good.*/

	if Type(color) ne RngIntElt or color lt 0 or color gt 1 then print "color must be either 0 or 1"; return 0; end if;

	psp:=removeReguliFromRegularSpread(phi,nsp1,lambdaSNest2);
	nsp:=replaceConnectedNestInRegularSpread(phi,psp,lambdaSNest2:color:=color);
	if Type(nsp) eq RngIntElt then return 0;
	else return buildTranslationPlane(nsp);
	end if;
end function;
