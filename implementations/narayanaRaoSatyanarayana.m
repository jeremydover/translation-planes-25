narayanaRaoSatyanarayanaImplementation:=function(r);
	if IsEven(r) or (r le 0) then print "r must be odd"; return 0; end if;
	
	F:=GF(5^r);
	V2:=VectorSpace(F,2);
	V4:=VectorSpace(F,4);
	M2:=MatrixAlgebra(F,2);
	M:=function(a,b);
		if b eq F!0 then return M2![a,0,0,a];
		else return M2![a,b,4*a^2/b + 3*a/b^2 + 2/b^3,4*a + 3/b];
		end if;
	end function;
	
	/* Our points are pairs of vectors in V4 */
	points:={@v:v in V4@};
	
	L:={{V4![0,0,r,s]:r,s in F}};
	for a in F do
		for b in F do
			myLine:={};
			for pq in V2 do
				rs:=pq*M(a,b);
				Include(~myLine,V4![pq[1],pq[2],rs[1],rs[2]]);
			end for;
			Include(~L,myLine);
		end for;
	end for;
	
	lines:={};
	for l in L do
		myLines:={l};
		V4set:=Set(V4) diff l;
		while #V4set gt 0 do
			x:=Rep(V4set);
			myLine:={x+y:y in l};
			Include(~myLines,myLine);
			V4set:=V4set diff myLine;
		end while;
		lines:=lines join myLines;
	end for;
	
	pi:=FiniteAffinePlane<points|lines>;
	Pi,P,L:=ProjectiveEmbedding(pi);
	return Pi;
end function;
