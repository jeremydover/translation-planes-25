load "library/bruck-bose.m";
rcComplexReplacementImplementation:=function(id,colorSequence);
	complexes:=AssociativeArray();
	complexes["complex-5-00001"]:=[[[0,0,1,0]]];
	complexes["complex-5-00002"]:=[[[0,0,3,1]],[[0,0,1,0]]];
	complexes["complex-5-00003"]:=[[[0,0,1,0]],[[0,0,3,4]]];
	complexes["complex-5-00004"]:=[[[0,0,3,1]],[[0,0,1,0]],[[0,0,3,4]]];
	complexes["complex-5-00005"]:=[[[1,3,1,0]],[[0,0,1,0]],[[1,4,1,0]]];
	complexes["complex-5-00006"]:=[[[0,0,3,1]],[[0,0,1,0]],[[0,0,0,1]],[[0,0,3,4]]];
	complexes["complex-5-00007"]:=[[[0,1,3,1],[4,3,1,0],[1,0,1,0],[0,0,1,0]],[[1,0,0,1]]];
	complexes["complex-5-00008"]:=[[[0,1,3,1],[4,3,1,0],[1,0,1,0],[0,0,1,0]],[[0,1,1,0]]];
	complexes["complex-5-00009"]:=[[[1,4,1,0],[4,3,1,0],[4,2,1,0],[1,0,1,0],[0,0,1,0],[0,2,1,0]],[[0,1,1,0]]];
	complexes["complex-5-00010"]:=[[[0,2,3,4]],[[0,2,3,1],[2,0,1,0],[3,1,1,0],[0,0,1,0],[0,2,1,0]]];
	complexes["complex-5-00011"]:=[[[4,3,3,4]],[[3,2,3,1],[2,0,1,0],[1,2,3,1],[4,0,1,0],[4,3,1,0]]];
	complexes["complex-5-00012"]:=[[[0,2,3,4]],[[3,4,1,0],[2,0,1,0],[3,1,1,0],[2,3,1,0],[0,0,1,0],[0,4,1,0]]];
	complexes["complex-5-00013"]:=[[[4,3,3,1],[3,4,3,1],[0,2,1,0],[2,0,1,0]],[[2,3,3,4],[4,2,0,1],[3,0,0,1],[0,4,3,4]]];

	if IsDefined(complexes,id) eq false then print "ID does not correspond to a replaceable complex."; return 0; end if;
	if Type(colorSequence) ne SeqEnum then print "colorSequence must be a sequence."; return 0; end if;
	if #colorSequence ne #complexes[id] then print "colorSequence must have the same length (",#complexes[id],") as the complex."; return 0; end if;
	if SequenceToSet(colorSequence) notsubset {0,1} then print "colorSequence must consist of 0/1 entries."; return 0; end if;
	
	phi:=buildFieldStructures(5,2);
	sp:=makeRegularSpread(phi);
	serializedReguli:=[];
	for i in [1..#complexes[id]] do
	    x:=complexes[id][i];
		if #x eq 1 then
			serializedReguli cat:= x[1];
		else
			/* Note: we are abusing the base function a bit...nsp1 is NOT a regular spread. However, all of the lines to be removed for lambdaSNest2 are still in nsp1, and since the removal does not require the field model, just set inclusion, we should be good.*/
			lambdaSNest:=convertReguliSerializedToLambdaS(phi,&cat x);
			psp:=removeReguliFromRegularSpread(phi,sp,lambdaSNest);
			sp:=replaceConnectedNestInRegularSpread(phi,psp,lambdaSNest:color:=colorSequence[i]);
			if Type(sp) eq RngIntElt then print "Replacement of nest ",i," failed."; return 0; end if;
		end if;
	end for;
	
	/*We have replaced all the nests, now replace the reguli.*/
	if #serializedReguli gt 0 then
		lambdaSReguli:=convertReguliSerializedToLambdaS(phi,serializedReguli);
		psp:=removeReguliFromRegularSpread(phi,sp,lambdaSReguli);
		sp:=replaceReguliInRegularSpread(phi,psp,lambdaSReguli);
		if Type(sp) eq RngIntElt then print "Replacement of reguli failed."; return 0; end if;
	end if;
	return buildTranslationPlane(sp);
end function;