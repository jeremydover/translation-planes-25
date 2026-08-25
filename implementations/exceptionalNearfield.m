exceptionalNearfieldImplementation:=function(index);
	case index:
		when "I":
			q:=5;
			mSet:={[0,-1,1,0],[1,-2,-1,-2]};
		when "II":
			q:=11;
			mSet:={[0,-1,1,0],[1,5,-5,-2],[4,0,0,4]};
		when "III":
			q:=7;
			mSet:={[0,-1,1,0],[1,3,-1,-2]};
		when "IV":
			q:=23;
			mSet:={[0,-1,1,0],[1,-6,12,-2],[2,0,0,2]};
		when "V":
			q:=11;
			mSet:={[0,-1,1,0],[2,4,1,-3]};
		when "VI":
			q:=29;
			mSet:={[0,-1,1,0],[1,-7,-12,-2],[16,0,0,16]};
		when "VII":
			q:=59;
			mSet:={[0,-1,1,0],[9,15,-10,-10],[4,0,0,4]};
		else print "index is not one of the allowed values"; return 0;
	end case;
	
	F:=GF(q);
	K<w>:=ext<F|2>;
	V,phi:=VectorSpace(K,F);
	M:=MatrixGroup<2,F|mSet>;
	f:=pmap<V->M|{<x,Rep({y:y in M|V![1,0]*y eq x})>:x in V|x ne V!0}>;
	
	/* Our points are ordered pairs of elements from K */
	points:={@<k1,k2>:k1,k2 in K@};
	
	/* mult is the product operation on the quasifield */
	mult:=function(a,b);
		if b eq 0 then return K!0;
		else return (phi(a)*f(phi(b)))@@phi;
		end if;
	end function;
	
	/* Standard affine coordinates for quasifield construction */
	lines:={{<x,mult(x,a)+b>:x in K}:a,b in K} join {{<c,y>:y in K}:c in K};
	pi:=FiniteAffinePlane<points|lines>;
	Pi,P,L:=ProjectiveEmbedding(pi);
	return Pi;
end function;