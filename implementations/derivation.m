load "library/reference-model.m";

derivationImplementation:=function(sourcePlane,derivationSet);

	Pi,P,L:=loadPackedProjectivePlane(sourcePlane);
	BSL:={P!x:x in derivationSet};
	derivationLine:=L!BSL;
	points:=SetToIndexedSet(Set(P) diff Set(derivationLine));
	
	/*Let's do the easy remaining lines first*/
	lines:= {};
	for p in Set(derivationLine) diff BSL do
		for l in Pencil(p) do
			if l ne derivationLine then
				Include(~lines,Set(l) diff Set(derivationLine));
			end if;
		end for;
	end for;
	
	/*Now pick one of the holdover lines. Every new line will meet it in one point, so
	we can iterate over these points to form our Baer subplanes.*/
	fixedLine:=Rep(lines);
	for p in fixedLine do
		/*Now we pick the line through p and a fixed point of the BSL, and build Baer subplanes
		  until the set is exhausted. We take out p and BSL[1].*/
		targetPoints:=Set(L!{p,Rep(BSL)}) diff {p,Rep(BSL)};
		while #targetPoints gt 0 do
			r:=Rep(targetPoints);
			B:=sub<Pi|{p,r} join BSL>;
			Include(~lines,Set(Points(B)) diff Set(derivationLine));
			targetPoints diff:= Set(Points(B));
			delete(B);
		end while;
	end for;
	
	pi:=FiniteAffinePlane<points|lines>;
	Pi,P,L:=ProjectiveEmbedding(pi);	
	return Pi;
end function;

IsDerivationSet:=function(Pi,derivationSet);
	P:=PointSet(Pi);
	L:=LineSet(Pi);
	q2:=Order(Pi);
	flag,q:=IsSquare(q2);
	if not(flag) then print "Plane does not have square order."; return 0; end if;
	BSL:={P!x:x in derivationSet};
	derivationLine:=L!BSL;

	/*First find a line that meets the deriviation line in a point off of the putative Baer subline.*/
	p:=Rep(Set(derivationLine) diff BSL);
	fixedLine:=Rep(Pencil(p) diff {derivationLine});
	
	flag:=true;
	for p in (Set(fixedLine) diff Set(derivationLine)) do
		/*Now we pick the line through p and a fixed point of the BSL, and build Baer subplanes
		  until the set is exhausted. We take out p and BSL[1].*/
		targetPoints:=Set(L!{p,Rep(BSL)}) diff {p,Rep(BSL)};
		while #targetPoints gt 0 do
			r:=Rep(targetPoints);
			B:=sub<Pi|{p,r} join BSL>;
			if Order(B) ne q then 
				flag:=false;
				break p;
			end if;
			targetPoints diff:= Set(Points(B));
			delete(B);
		end while;
	end for;
	return flag;
end function;