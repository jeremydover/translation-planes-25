raoRodabaughWilkeZemmerImplementation:=function(index,subindex);
	case index:
		when "I":
			q:=5;
			mSet:={[0,-1,1,0],[1,-2,-1,-2]};
			case subindex:
				when 1:
					tSeq:=[1,0,0,4];
				when 2:
					tSeq:=[1,0,1,4];
				else printf "I-%o is not a valid specification",subindex; return 0;
			end case;
		when "II":
			q:=11;
			mSet:={[0,-1,1,0],[1,5,-5,-2],[4,0,0,4]};
			case subindex:
				when 1:
					tSeq:=[1,0,0,10];
				else printf "II-%o is not a valid specification",subindex; return 0;
			end case;
		when "III":
			q:=7;
			mSet:={[0,-1,1,0],[1,3,-1,-2]};
			case subindex:
				when 1:
					tSeq:=[1,0,0,2];
				when 3:
					tSeq:=[1,0,0,6];
				when 4:
					tSeq:=[1,0,1,6];
				else printf "III-%o is not a valid specification",subindex; return 0;
			end case;
		when "V":
			q:=11;
			mSet:={[0,-1,1,0],[2,4,1,-3]};
			case subindex:
				when 1:
					tSeq:=[1,0,0,10];
				when 2:
					tSeq:=[1,0,1,10];
				else printf "V-%o is not a valid specification",subindex; return 0;
			end case;
		when "VI":
			q:=29;
			mSet:={[0,-1,1,0],[1,-7,-12,-2],[16,0,0,16]};
			case subindex:
				when 1:
					tSeq:=[1,0,27,28];
				else printf "VI-%o is not a valid specification",subindex; return 0;
			end case;
		else print "index is not one of the allowed values"; return 0;
	end case;
	
	F:=GF(q);
	V:=VectorSpace(F,2);
	MA:=MatrixAlgebra(F,2);
	MG:=MatrixGroup<2,F|mSet>;
	phi:=pmap<V->MA|{<x,Rep({y:y in MG|V![1,0]*y eq x})>:x in V|x ne V!0} join {<V![0,0],MA![0,0,0,0]>}>;
	psi:=map<MA->V|x:->V![x[1][1],x[1][2]]>;
	nfMult:=function(x,y);
		return psi((phi(y)*phi(x)));
	end function;
	T:=MA!tSeq;
	G:=sub<MG|{phi(nfMult(x*T,psi(phi(x)^(-1)))):x in V|x ne 0}>;

	/* Our points are ordered pairs of elements from K */
	points:={@<v1,v2>:v1,v2 in V@};
	
	/* mult is the product operation on the quasifield */
	mult:=function(b,a);
		if a eq 0 then return V!0;
		elif phi(a) in G then return nfMult(a,b);
		else return nfMult(a,b*T);
		end if;
	end function;
	
	/* Standard affine coordinates for quasifield construction */
	lines:={{<x,mult(x,a)+b>:x in V}:a,b in V} join {{<c,y>:y in V}:c in V};
	pi:=FiniteAffinePlane<points|lines>;
	Pi,P,L:=ProjectiveEmbedding(pi);
	return Pi;
end function;