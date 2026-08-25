andreImplementation:=function(q,d,automorphismSequence);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	if d lt 2 then print "d must be at least 2"; return 0; end if;
	if Type(automorphismSequence) ne SeqEnum then print "automorphismSequence must be a sequence."; return 0; end if;
	if #automorphismSequence ne q-2 then print "automorphismSequence must have length q-2"; return 0; end if;
	if not(forall{x:x in automorphismSequence|0 le x and d-1 ge x}) then print "All automorphismSequence entries must be between 0 and d-1"; return 0; end if;
	F:=GF(q);
	w:=PrimitiveElement(F);
	K:=ext<F|d>;
	
	/* Our points are ordered pairs of elements from K */
	points:={@<k1,k2>:k1,k2 in K@};
	
	/* mult is the product operation on the quasifield */
	mult:=function(a,b);
		if b eq 0 then return K!0;
		else
		  n:=Log(Norm(b,F));
		  if n eq 0 then return a*b;
		  else return a^(q^automorphismSequence[n])*b;
		  end if;
		 end if;
	end function;
	
	/* Standard affine coordinates for quasifield construction */
	lines:={{<x,mult(x,a)+b>:x in K}:a,b in K} join {{<c,y>:y in K}:c in K};
	pi:=FiniteAffinePlane<points|lines>;
	Pi,P,L:=ProjectiveEmbedding(pi);
	return Pi;
end function;
