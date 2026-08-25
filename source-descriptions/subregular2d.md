# Planes from subregular spreads of PG(3,q)

## Reference
Original construction from:
R.H. Bruck. Construction problems of finite projective planes, in Combinatorial Mathematics and Its Applications (R.C. Bose and T.A. Dowling, Ed.), Ch. 27, pp. 426–514, Univ. of North Carolina Press, Chapel Hill, NC, 1969.

Also relevant is:
W. F. Orr, The Miquelian Inversive Plane IP(q) and the Associated Projective Planes. Ph.D. dissertation, University of Wisconsin, Madison, 1973.

This paper provides the computational model for defining reguli in a regular spread that we use here, as well as proving that a subregular plane can be obtained by simultaneously reversing a set of pairwise disjoint reguli in a regular spread.

## Instance Data
q
=
Type: Integer
Description: The order of the field underlying the projective 3-space PG(3,q) containing the base regular spread.

reguli
======
Type: Sequence of integers
Description: From Bruck, a regular spread of PG(3,q) can be modeled using GF(q^2) together with an additional point ∞. In this model, each regulus of the regular spread corresponds to a circle in the resulting inversive geometry, and thus there is a unique circle inversion whose fixed points are exactly the points of the circle. Following Orr, we can thus label a regulus with a matrix:
[λ	  a ]
[b	-λ^q],
where λ is in GF(q^2), a,b are in GF(q), and λ^(q+1)+ab is non-zero. Two such matrices represent the same circle if and only if they are scalar multiples of each other.

To ease implementation, we will make several simplifications. First, no collection of pairwise disjoint reguli can ever require all lines of the spread to be reverse, so we assume that the point labelled ∞ is never in a regulus to be reversed; this implies we may take b=1 without loss of generality. Second, rather than store the circle inversion, we will store parameters of a linear transformation which maps the circle λ=0, a=b=1 onto the target circle. It takes a bit of arithmetic, but it is not hard to show that the linear transformation x -> λ+sx, where s^(q+1) = λ^(q+1)+ab, performs this mapping. Each regulus is represented by the pair (λ,s).

Finally, to avoid having to deal with field element representations, Our field elements will be represented as vectors in a polynomial basis over the prime field (namely those based on Magma's canonical Conway polynomials), thus allowing these to assuredly be sequences of integers. The polynomials are documented in the library/bruck-bose.m code. Multiple reguli can be given in a single sequence; the length of the sequence will indicate the number present.

### Example
```json
{"q":7,"reguli":[0,0,1,0,0,0,2,0]}
```

## Implementation

### Function

subregular2dImplementation(q,reguli);

### Input

q: integer that is a power of a prime, possibly itself a prime
reguli: sequence of integers between 0 and p-1, include, where p is the prime dividing q

### Output

A Magma PlaneProj object modeling the subregular plane of order q^2 obtained from applying the Bruck Bose construction to a subregular spread obtained by reversing a set of reguli in a regular spread.

### Notes
