load "library/bruck-bose.m";
rcNestReplacementImplementation:=function(id);
	nests:=AssociativeArray();
	nests["web-5-2-0001"]:=[[1,0,1,0],[0,1,3,1],[0,0,1,0],[4,3,1,0]];
	nests["web-5-2-0002"]:=[[0,2,3,1],[2,0,1,0],[3,1,1,0],[0,0,1,0],[0,2,1,0]];
	nests["web-5-2-0003"]:=[[3,4,1,0],[4,0,3,1],[3,1,1,0],[0,0,1,0],[1,4,3,1]];
	nests["web-5-2-0004"]:=[[4,0,1,0],[2,0,3,1],[1,2,3,1],[0,0,1,0],[4,2,1,0],[3,2,1,0]];
	nests["web-5-2-0005"]:=[[4,3,1,0],[0,2,1,0],[1,0,1,0],[1,4,1,0],[0,0,1,0],[4,2,1,0]];
	nests["web-5-2-0006"]:=[[3,4,1,0],[2,0,1,0],[3,1,1,0],[2,3,1,0],[0,0,1,0],[0,4,1,0]];
	nests["web-5-2-0007"]:=[[1,4,3,1],[1,1,3,1],[1,2,3,1],[0,0,1,0],[1,3,1,0],[2,2,1,0]];
	nests["web-5-2-0010"]:=[[0,1,1,0],[1,2,3,1],[0,0,1,0],[4,2,1,0],[2,4,1,0],[2,3,1,0],[3,2,1,0]];
	nests["web-5-2-0011"]:=[[0,4,3,1],[1,2,1,0],[1,1,1,0],[3,1,3,1],[0,4,1,0],[0,0,1,0],[4,2,1,0]];
	nests["web-5-2-0013"]:=[[2,0,1,0],[1,2,1,0],[1,1,1,0],[0,1,1,0],[3,1,3,1],[3,1,1,0],[0,0,1,0],[4,2,1,0]];

	if IsDefined(nests,id) eq false then print "ID does not correspond to a replaceable nest."; return 0; end if;
	
	phi:=buildFieldStructures(5,2);
	lambdaSNest:=convertReguliSerializedToLambdaS(phi,&cat nests[id]);
	nsp:=buildConnectedNestSpread(phi,lambdaSNest);
	if Type(nsp) eq RngIntElt then return 0;
	else return buildTranslationPlane(nsp);
	end if;
end function;