# (q-1)-nest Construction - Flock Derived

## Reference
Baker, R.D. and Ebert, G.L., Nests of size (q−1) and another family of translation planes. J. London Math. Soc. 38:341–355, 1988.

## Instance Data
q
=
Type: Integer
Description: Order of ground field for (q-1)-nest construction; q must be an odd prime power.

b
=
Type: Sequence of integers
Description: The vector representation over the prime field of an element of GF(q) which satisfies: b(b+1) is a nonzero square and -1/(b*w) is a nonzero square, where w is the norm of the primitive element of the field over GF(q).

mu
==
Type: Sequence of integers
Description: The vector representation over the prime field of an element of GF(q^2). This field element defines a circle from the flock of q+1 circles that contains both 0 and infinity. In order for this construction to work, this circle must be disjoint from the circle:
[1  1]
[b -1]
which defines the base circle of the nest; this condition is checked as part of the construction.

### Example
```json
{"q":5,"b":[2],"mu":[3,1]}
```

## Implementation

### Function

bakerEbertQMinusOneNestFlockDerivedImplementation(q,b,mu);

### Input

q: integer that is a power of an odd prime, possibly itself a prime
b: sequence of integers representing a field element as above
mu: sequence of integers representing a field element as above

### Output

If successful, a Magma PlaneProj object modeling a (q-1)-nest plane of order q^2 which has been derived using one of the reguli in the defining flock disjoint from the nest.

### Notes
