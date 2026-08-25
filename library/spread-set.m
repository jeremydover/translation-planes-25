/*This library file contains Magma functions that implement the creation of a plane from a spread set of matrices. To avoid complications with representing field elements in non-prime order fields, we assume the ground field of our matrix is always a prime, inflating our matrix entries by replacing each field element with the companion matrix of its minimal polynomial, as needed. */

buildTranslationPlane:=function(q,mxSeq);
	if not(IsPrimePower(q)) then print "q must be a prime power"; return 0; end if;
	p:=PrimeDivisors(q)[1];
	F:=GF(p);
	flag,n:=IsSquare(#mxSeq[1]);
	if flag eq false then print "sequences in mxSeq must have length a perfect square"; return 0; end if;
	M:=MatrixAlgebra(F,n);
	V:=VectorSpace(F,n);
	points:={@<v1,v2>:v1,v2 in V@};
	lines:={{<v1,v>:v1 in V}:v in V};
	for mx in mxSeq do
		A:=M!mx;
		for v in V do
			Include(~lines,{<v+v1*A,v1>:v1 in V});
		end for;
	end for;
	pi:=FiniteAffinePlane<points|lines>;
	Pi,P,L:=ProjectiveEmbedding(pi);
	return Pi;
end function;