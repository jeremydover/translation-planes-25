hallImplementation:=function(q);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	F:=GF(q);
	K<w>:=ext<F|2>;
	/* f is a degree 2 irreducible polynomial over GF(q) */
	f:=MinimalPolynomial(w);
	r:=(F!-1)*Coefficient(f,1);
	V,phi:=VectorSpace(K,F);
	
	/* Our points are ordered pairs of elements from K */
	points:={@<k1,k2>:k1,k2 in K@};
	
	/* mult is the product operation on the quasifield */
	mult:=function(a,b);
		x:=phi(a)[1];
		y:=phi(a)[2];
		u:=phi(b)[1];
		v:=phi(b)[2];
		if v eq F!0 then return (V![x*u,y*u])@@phi;
		else return (V![x*u-y/v*Evaluate(f,u),x*v-y*u+y*r])@@phi;
		end if;
	end function;
	
	/* Standard affine coordinates for quasifield construction */
	lines:={{<x,mult(x,a)+b>:x in K}:a,b in K} join {{<c,y>:y in K}:c in K};
	pi:=FiniteAffinePlane<points|lines>;
	Pi,P,L:=ProjectiveEmbedding(pi);
	return Pi;
end function;
