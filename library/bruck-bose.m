/*This library file contains Magma functions that implement switching in regular spreads of PG(n,q), for odd n, as well as the creation of a projective plane from those spreads. We will endeavor to make as many functions generic in n as possible; however PG(3,q) is genuinely different (not least of which for the implementation of nest replacement), and may require special treatment.*/

/*A note on data representation. Theoretically, it is typical to model the regular spread of PG(2n-1,q) as the field GF(q^n) plus the symbol infinity, using the inversive plane/circle geometry model of Bruck. However, representing field elements is problematic. For this dataset, we are choosing to use Magma's canonical field representation, taking a polynomial basis in its canonical primitive element. A table of minimal polynomials for these representations appears here:

GF(2^2): x^2 + x + 1
GF(2^3): x^3 + x + 1
GF(2^4): x^4 + x + 1
GF(2^5): x^5 + x^2 + 1
GF(2^6): x^6 + x^4 + x^3 + x + 1
GF(2^7): x^7 + x + 1
GF(2^8): x^8 + x^4 + x^3 + x^2 + 1
GF(2^9): x^9 + x^4 + 1
GF(2^10): x^10 + x^6 + x^5 + x^3 + x^2 + x + 1
GF(2^11): x^11 + x^2 + 1
GF(2^12): x^12 + x^7 + x^6 + x^5 + x^3 + x + 1
GF(2^13): x^13 + x^4 + x^3 + x + 1
GF(2^14): x^14 + x^7 + x^5 + x^3 + 1

GF(3^2): x^2 + 2*x + 2
GF(3^3): x^3 + 2*x + 1
GF(3^4): x^4 + 2*x^3 + 2
GF(3^5): x^5 + 2*x + 1
GF(3^6): x^6 + 2*x^4 + x^2 + 2*x + 2
GF(3^7): x^7 + 2*x^2 + 1
GF(3^8): x^8 + 2*x^5 + x^4 + 2*x^2 + 2*x + 2

GF(5^2): x^2 + 4*x + 2
GF(5^3): x^3 + 3*x + 3
GF(5^4): x^4 + 4*x^2 + 4*x + 2
GF(5^5): x^5 + 4*x + 3
GF(5^6): x^6 + x^4 + 4*x^3 + x^2 + 2

GF(7^2): x^2 + 6*x + 3
GF(7^3): x^3 + 6*x^2 + 4
GF(7^4): x^4 + 5*x^2 + 4*x + 3

GF(11^2): x^2 + 7*x + 2
GF(11^3): x^3 + 2*x + 9
GF(11^4): x^4 + 8*x^2 + 10*x + 2

GF(13^2): x^2 + 12*x + 2
GF(13^3): x^3 + 2*x + 11
GF(13^4): x^4 + 3*x^2 + 12*x + 2
*/

/*This function builds the basic field structures, and returns the mapping phi. The other structures can be easily recovered from phi via: K:=Domain(phi); V:=Image(phi); F:=PrimeField(K); */
buildFieldStructures:=function(q,d);
	K:=GF(q^d);
	F:=PrimeField(K);
	V,phi:=VectorSpace(K,F);
	return phi;
end function;

convertRegulusLambdaABToLambdaS:=function(lambda,a,b);
	K:=Parent(lambda);
	w:=PrimitiveElement(K);
	q:=Characteristic(K)^(Degree(K) div 2);
	V,phi:=VectorSpace(K,PrimeField(K));
	norms:=[Norm(w^i,GF(q)):i in [0..q-2]];
	if b eq K!0 then print "Circles containing infinity are not supported."; return 0,0; end if;
	if lambda^(q+1)+a*b eq 0 then print "The given lambda, a and b do not represent a circle inversion."; return 0,0; end if;
	l1:=lambda/b;
	ns:=Norm(l1,GF(q))+a/b;
	sPos:=Position(norms,ns)-1;
	s:=w^sPos;
	return l1,s;
end function;

convertRegulusLambdaSToSerialized:=function(lambda,s);
	K:=Parent(lambda);
	V,phi:=VectorSpace(K,PrimeField(K));
	return ElementToSequence(phi(lambda)) cat ElementToSequence(phi(s));
end function;

convertRegulusLambdaABToSerialized:=function(lambda,a,b);
	lambda,s:=convertRegulusLambdaABToLambdaS(lambda,a,b);
	return convertRegulusLambdaSToSerialized(lambda,s);
end function;

convertRegulusLambdaSToLambdaAB:=function(lambda,s);
	K:=Parent(lambda);
	q:=Characteristic(K)^(Degree(K) div 2);
	return lambda,s^(q+1)-lambda^(q+1),1;
end function;

convertRegulusSerializedToLambdaS:=function(phi,seq);
	if not(IsEven(#seq)) then print "Input regulus sequence is invalid...must have even length."; return 0,0; end if;
	seqLen:=#seq div 2;
	V:=Image(phi);
	K:=Domain(phi);
	w:=PrimitiveElement(K);
	q:=Characteristic(K)^(Degree(K) div 2);
	F:=GF(q);
	norms:=[Norm(w^i,F):i in [0..q-2]];
	lambda:=(V!seq[1..seqLen])@@phi;
	sRaw:=(V!seq[seqLen+1..#seq])@@phi;
	if sRaw eq K!0 then print "Value for s cannot be 0."; return 0,0; end if;
	sPos:=Position(norms,Norm(sRaw,F))-1;
	s:=w^sPos;
	return lambda,s;
end function;

convertRegulusSerializedToLambdaAB:=function(phi,seq);
	lambda,s:=convertRegulusSerializedToLambdaS(phi,seq);
	lambda,a,b:=convertRegulusLambdaSToLambdaAB(lambda,s);
	return lambda,a,b;
end function;

convertReguliSerializedToLambdaS:=function(phi,reguli);
	K:=Domain(phi);
	q:=Characteristic(K)^(Degree(K) div 2);
	F:=GF(q);
	V:=Image(phi);
	w:=PrimitiveElement(K);
	norms:=[Norm(w^i,F):i in [0..q-2]];
	vectors:=Partition(reguli,2*Dimension(V));
	
	lambdaSSeq:=[];
	for seq in vectors do
		lambda,s:=convertRegulusSerializedToLambdaS(phi,seq);
		Append(~lambdaSSeq,<lambda,s>);
	end for;
	return lambdaSSeq;
end function;

/* The following are utility functions which create artifacts from the lambda-s representation of a regulus that are needed for replacement. The first produces a set of field elements which represent lines in the regulus...these are used for deletion. The second lifts the lambda-s mapping from the inversive plane into PG(3,q), so that we can map a replacement set of lines from N(x)=1 to our target regulus in a canonical manner. */

enumerateRegulusElementsFromLambdaS:=function(lambda,s);
	K:=Parent(lambda);
	q:=Characteristic(K)^(Degree(K) div 2);
	w:=PrimitiveElement(K);
	n1:={w^((q-1)*x):x in [0..q]};
	return {lambda+s*x:x in n1};
end function;

liftLambdaSMappingToMatrix:=function(lambda,s);
	K:=Parent(lambda);
	q:=Characteristic(K)^(Degree(K) div 2);
	F:=GF(q);
	w:=PrimitiveElement(K);
	norms:=[Norm(w^i,F):i in [0..q-2]];
	
	wm:=CompanionMatrix(MinimalPolynomial(w));
	A:=Parent(wm);
	if lambda eq K!0 then 
		B:=A!0;
	else
		B:=wm^Log(lambda);
	end if;
	if s eq K!0 then print "s parameter cannot be 0"; return 0; end if;
	sPos:=Position(norms,Norm(s,F))-1;
	return BlockMatrix(2,2,[A!1,B,A!0,wm^sPos]);
end function;
	
/*These are the basic functions to create and operate within a regular spread */

makeRegularSpread:=function(phi);
	K:=Domain(phi);
	V:=Image(phi);
	W:=VectorSpace(PrimeField(K),2*Dimension(V));
	Jinf:=sub<W|[W!(ElementToSequence(V!0) cat ElementToSequence(v)):v in Basis(V)]>;
	sp:={Jinf} join {sub<W|[W!(ElementToSequence(v) cat ElementToSequence(phi(k*(v@@phi)))):v in Basis(V)]>:k in K};
	return sp;
end function;

removeReguliFromRegularSpread:=function(phi,sp,lambdaSReguli);
	psp:=sp;
	V:=Image(phi);
	W:=Generic(Rep(sp));
	fieldReguli:={enumerateRegulusElementsFromLambdaS(x[1],x[2]):x in lambdaSReguli};
	for k in &join fieldReguli do
		Exclude(~psp,sub<W|[W!(ElementToSequence(v) cat ElementToSequence(phi(k*(v@@phi)))):v in Basis(V)]>);
	end for;
	return psp;
end function;

replaceReguliInRegularSpread:=function(phi,psp,lambdaSReguli);
	K:=Domain(phi);
	q:=Characteristic(K)^(Degree(K) div 2);
	w:=PrimitiveElement(K);
	V:=Image(phi);
	W:=Generic(Rep(psp));
	J1opp:=sub<W|[W!(ElementToSequence(v) cat ElementToSequence(phi((v@@phi)^q))):v in Basis(V)]>;
	wm:=CompanionMatrix(MinimalPolynomial(w));
	A:=Parent(wm);
	ker:=BlockMatrix(2,2,[wm,A!0,A!0,wm]);
	R1opp:={sub<W|[x*ker^i:x in Basis(J1opp)]>:i in {0..q}};
	collineations:={liftLambdaSMappingToMatrix(x[1],x[2]):x in lambdaSReguli};
	for psi in collineations do
		psp join:= {sub<W|[x*psi:x in Basis(r)]>:r in R1opp};
	end for;
	return psp;
end function;

/* Now the question is how do we reverse a regulus in a spread which is not regular, and thus does not have an underlying model as the inversive plane. We no longer have a circle inversion model, so we're just left with vector spaces. From a data perspective, we really only want our JSON to be storing prime field elements; however, blowing up the vector spaces to the prime field if the ground field is not prime gives us the reconstruction problem, very concretely in order 64, which is in our design space. Suppose we have a regulus in PG(3,8). As a vector space, each element is a 2-dimensional subspace over GF(8), with the points being the 1-dimensional subspaces. But in the expansion, each regulus line is a 6-dimensional vector space over GF(2), with the points be a set of 9 3-dimensional subspaces. But which 9? So to make this work, in the abstract sense we need to use a different data structure for reguli...we have to keep the field structure around. So we may assume that a regulus will be given as a sequence of q+1 2-dimensional subspaces over GF(q), where q need not be prime.*/

findOppositeRegulus:=function(regulus);
	W:=Generic(regulus[1]);
	K:=Field(W);
	e1:=Basis(regulus[1])[1];
	e2:=Basis(regulus[1])[2];
	e1p:=Rep({x:x in regulus[2]|e1+x in regulus[3]});
	e2p:=Rep({x:x in regulus[2]|e2+x in regulus[3]});
	return {sub<W|{e1,e1p}>} join {sub<W|{k*e1+e2,k*e1p+e2p}>:k in K};
end function;

/*These functions allows us to deal with circles in the regular spread that do contain infinity, by using the raw representation as a set of field elements. We will use the size of the input to determine if the infinity point is in the circle or not.*/

prepareRawCircleForRegulusReversal:=function(phi,circle);
	K:=Domain(phi);
	V:=Image(phi);
	flag,q:=IsSquare(#K);
	F:=GF(q);
	W2:=VectorSpace(F,4);
	V2,phi2:=VectorSpace(K,F);
	if #circle eq q then
		convertedCircle:=[sub<W2|[W2!(ElementToSequence(V2!0) cat ElementToSequence(v2)):v2 in Basis(V2)]>];
	else
		convertedCircle:=[];
	end if;
	
	return convertedCircle cat [sub<W2|[W2!(ElementToSequence(v2) cat ElementToSequence(phi2(k*(v2@@phi2)))):v2 in Basis(V2)]>:k in circle];
end function;

removeRawCircleFromSpread:=function(phi,sp,circle);
	K:=Domain(phi);
	V:=Image(phi);
	W:=Generic(Rep(sp));
	flag,q:=IsSquare(#K);
	
	if #circle eq q then
		Exclude(~sp,sub<W|[W!(ElementToSequence(V!0) cat ElementToSequence(v)):v in Basis(V)]>);
	end if;
	for k in circle do
		Exclude(~sp,sub<W|[W!(ElementToSequence(v) cat ElementToSequence(phi(k*(v@@phi)))):v in Basis(V)]>);
	end for;
	return sp;
end function;
	
addRegulusReplacementToSpread:=function(phi,psp,oppreg);
	W:=Generic(Rep(psp));
	K:=Domain(phi);
	V:=Image(phi);
	flag,q:=IsSquare(#K);
	F:=GF(q);
	W2:=VectorSpace(F,4);
	V2,phi2:=VectorSpace(K,F);
	
	for x in oppreg do
		w2vectors:={};
		for w2 in x do
			Include(~w2vectors,W!(ElementToSequence(phi((V2![w2[1],w2[2]])@@phi2)) cat ElementToSequence(phi((V2![w2[3],w2[4]])@@phi2))));
		end for;
		Include(~psp,sub<W|w2vectors>);
	end for;
	return psp;
end function;

/* OK, now we're getting nests in the mix, but we're also planning for mixed replacements as well. Generically, we're going to call a regulus or a nest a "web", and we'd like to get to the point where we can replace a set of pairwise disjoint webs in a regular spread. Fun fact: we don't actually need to store the webs separately. We can just throw them in a single sequence, and sort them by connectivity. More over, we can distinguish a nest from a regulus by size of the connected component. Excellent. */

webConnectedComponents:=function(lambdaSNest);
	vertices:={@ x:x in lambdaSNest @};
	setReguli:=[enumerateRegulusElementsFromLambdaS(lambdaSNest[i][1],lambdaSNest[i][2]):i in [1..#lambdaSNest]];
	Gr:=Graph<vertices|{{x,y}:x,y in vertices|x ne y and #(setReguli[Position(lambdaSNest,x)] meet setReguli[Position(lambdaSNest,y)]) gt 0}>;
	C:=Components(Gr);
	return C;
end function;

/*This function ensures that for a connected nest, the reguli are sorted in such a way that all reguli after the first intersect some regulus that comes before us. When we go to replace a nest, this means we can make a definitive determination of whether the nest is replaceable by simply proceeding in linear order, and not worry that we made replacement decisions that were suboptimal for future choices. Basically, once the first half regulus is fixed, each subsequent one is already forced.*/

sortNestByConnectivity:=function(lambdaSNest);
	components:=webConnectedComponents(lambdaSNest);
	if #components gt 1 then print "Input nest is not connected."; return 0; end if;
	setReguli:=[enumerateRegulusElementsFromLambdaS(lambdaSNest[i][1],lambdaSNest[i][2]):i in [1..#lambdaSNest]];
	orderedNest:=[lambdaSNest[1]];
	coveredLines:=setReguli[1];
	remainder:={2..#lambdaSNest};
	while #remainder gt 0 do
		cand:={i:i in remainder|#(coveredLines meet setReguli[i]) gt 0};
		for i in cand do
			Append(~orderedNest,lambdaSNest[i]);
			coveredLines join:= setReguli[i];
			Exclude(~remainder,i);
		end for;
	end while;
	return orderedNest;
end function;

/* Let's replace a simple connected nest first. That will get us most of the way through order 25. This proceeds pretty much the same way as subregular replacement does, except we use opposite half-reguli, and make sure we can weave them together. Note: color lets us canonicalize the replacement. The lambda-s model ensures that the lines of the half-regulus are canonically mapped to the lines of N(x)=1. color 0 assumes we pick the half-regulus with the image of J1opp under this canonical map. color 1 picks the other half regulus. This is irrelevant for connected nests, as the Bruck kernel ensures the two replacements are isomorphic, but for two disjoint nests, it may be that picking different colors between the nests for replacement may lead to nonisomorphic planes. Spoiler: this actually does happen in order 49.*/

replaceConnectedNestInRegularSpread:=function(phi,psp,lambdaSNest: color:=2);
	color:=color mod 2;
	K:=Domain(phi);
	q:=Characteristic(K)^(Degree(K) div 2);
	if IsEven(q) then print "Nest replacement requires q odd"; return 0; end if;
	w:=PrimitiveElement(K);
	V:=Image(phi);
	W:=Generic(Rep(psp));
	J1opp:=sub<W|[W!(ElementToSequence(v) cat ElementToSequence(phi((v@@phi)^q))):v in Basis(V)]>;
	wm:=CompanionMatrix(MinimalPolynomial(w));
	A:=Parent(wm);
	ker:=BlockMatrix(2,2,[wm,A!0,A!0,wm]);
	
	/*Pre-compute the base opposite half reguli by color*/
	r:=[{sub<W|[x*ker^(2*i+c):x in Basis(J1opp)]>:i in [0..(q-1) div 2]}:c in [0..1]];
	
	nest:=sortNestByConnectivity(lambdaSNest);
	/*Set the replacement for the first regulus to be the defined color*/
	replacement:={sub<W|[x*liftLambdaSMappingToMatrix(nest[1][1],nest[1][2]):x in Basis(line)]>:line in r[color+1]};
	
	/*OK, now we can loop through the rest of the nest elements, picking replacements as we go*/
	for i in [2..#nest] do
		lineTest1:=sub<W|[x*liftLambdaSMappingToMatrix(nest[i][1],nest[i][2]):x in Basis(J1opp)]>;
		lineTest2:=sub<W|[x*ker*liftLambdaSMappingToMatrix(nest[i][1],nest[i][2]):x in Basis(J1opp)]>;
		if {Dimension(lineTest1 meet x):x in replacement} eq {0} then
			replacement join:= {sub<W|[x*liftLambdaSMappingToMatrix(nest[i][1],nest[i][2]):x in Basis(line)]>:line in r[1]};
		elif {Dimension(lineTest2 meet x):x in replacement} eq {0} then
			replacement join:= {sub<W|[x*liftLambdaSMappingToMatrix(nest[i][1],nest[i][2]):x in Basis(line)]>:line in r[2]};
		else
			print "Nest is not replaceable with Bruck half-reguli.";
			return 0;
		end if;
	end for;
	return psp join replacement;
end function;

/*Since we'll have a lot of different nest types (hopefully), we'll just do a generic builder here instead of recreating it repeatedly*/
buildConnectedNestSpread:=function(phi,lambdaSNest);
	sp:=makeRegularSpread(phi);
	psp:=removeReguliFromRegularSpread(phi,sp,lambdaSNest);
	nsp:=replaceConnectedNestInRegularSpread(phi,psp,lambdaSNest);
	return nsp;
end function;

/*This one may be a bit controversial too. Think how to do it properly (I'll just talk it through for PG(3,q)...then analogize):
A spread line is a 2-dimensional vector space over GF(q), so it contains q^2-1 non zero vectors. These form q+1 "disjoint" 1-dimensional subspaces, each containing q-1 vectors and the zero vector. 

In our representation, a spread line is a 2d dimensional subspace over GF(p), where q=p^d for p prime. Now we have p^2d-1 = q^2-1 nonzero vectors, just like before, for which we have p^d+1 "disjoint" d-dimensional subspaces, each containing p^d-1 vectors and the zero vector. What we do not have is a computationally easy way to determine which d-dimensional subspaces over GF(p) correspond to the 1-dimensional subspaces over GF(q), but as we'll see in a minute, it doesn't matter.

Now for the Bruck Bose construction, we embed our spread in the hyperplane at infinity (let's call it z=0). Our points are the points of PG(4,q) outside the z=0 hyperplane. Since we have homogeneous coordinates, we may take a representative for each such point which has z=1, and thus each point of our plane is associated with a unique 4-dimensional vector over GF(q), of which there are q^4.

In our representation, we are reusing the vector space W, which is a 4d dimensional vector space over GF(p), and thus has p^4d = q^4 vectors. 

For the lines of Bruck-Bose, we take the planes of PG(4,q) that meet z=0 in a spread line. We can "parameterize" this by, for each spread line s, pick a point P off the z=0 hyperplane, calculate the plane containing P and the spread line s, and find the points off z=0. Well, every such point can be represented as a linear combination of the point P and a point Q on s. Moreover, the "coefficient" of P in the linear combination must not be zero, since otherwise the point will be on hyperplane. Thus we may take P+kQ for all k in GF(q) as our points.

In our representation, but looping over the spread line as a vector space, we will get every point on the line, since we get all scalar multiples of Q in the vector space.
*/

buildTranslationPlane:=function(sp);
	W:=Generic(Rep(sp));
	points:={@ w:w in W @};
	lines:={};
	for s in sp do
		myW:=Set(W);
		while #myW gt 0 do
			x:=Rep(myW);
			line:={x+y:y in s};
			myW:= myW diff line;
			Include(~lines,line);
		end while;
	end for;
	pi:=FiniteAffinePlane<points|lines>;
	Pi,P,L:=ProjectiveEmbedding(pi);
	return Pi;
end function;
	
	
