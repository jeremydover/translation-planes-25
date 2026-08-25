load "implementations/fisherFlock.m";

fisherFlockReplacementDerivedImplementation:=function(q);
	if not(IsPrimePower(q)) then print "q is not a prime power"; return 0; end if;
	if IsEven(q) then print "q must be odd"; return 0; end if;
	
	F:=GF(q);
	K<beta>:=ext<F|2>;
	V,phi:=VectorSpace(K,F);
	epsilon:=beta^((q+1) div 2);
	w:=epsilon^2;
	W:=VectorSpace(F,4);
	sp:={sub<W|W![1,0,0,0],W![0,1,0,0]>} join {sub<W|W![a,w*b,1,0],W![b,a,0,1]>:a,b in F};
	
	target:=(q mod 4) eq 3 select 1 else w;
	nestReguli:=[{sub<W|W![a,w*b,1,0],W![b,a,0,1]>:a,b in F|w*(b-f)^2 eq a^2+target}:f in F];
	nestLines:=&join nestReguli;
	sp:=sp diff nestLines;
	
	MG:=MatrixGroup<4,F|{[1,0,0,0,0,1,0,0,0,w*f,1,0,f,0,0,1]:f in F}>;
	P:=MinimalPolynomial(beta,F);
	s:=Coefficient(P,1)*(-1/2);
	flag,t:=IsSquare(w*(1/4*(Coefficient(P,1))^2-Coefficient(P,0)));
	M:=MatrixAlgebra(F,4);
	ker:=Transpose(M![s,t/w,0,0,t,s,0,0,0,0,s,t/w,0,0,t,s]);
	
	candidateAB:={<a,b>:a,b in F|w*b^2-a^2 eq target};
	if (q mod 4) eq 1 then candidateAB diff:= {<0,b>:b in F}; end if;
	a:=Rep(candidateAB)[1];
	b:=Rep(candidateAB)[2];
	sp join:= {sub<W|W![a,w*b,1,0]*T*ker^j,W![0,target,b,a]*T*ker^j>:T in MG,j in {0..q by 2}};
	
	/*This has reproduced the nest replacement*/
	
	L:=sub<W|W![a,w*b,1,0],W![-b,-a,0,1]>;
	regulus:=[sub<W|W![1,0,0,0],W![0,1,0,0]>] cat [sub<W|{x*T:x in Basis(L)}>:T in MG];
	sp:=sp diff SequenceToSet(regulus);
	oppreg:=findOppositeRegulus(regulus);
	
	nsp:=addRegulusReplacementToSpread(phi,sp,oppreg);
	return buildTranslationPlane(nsp);

end function;
