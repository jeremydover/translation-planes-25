# 2(q-1)-nest Construction

## Reference
Baker, R.D. and Ebert, G.L., Nests of size (q−1) and another family of translation planes. J. London Math. Soc. 38:341–355, 1988.

Dover, J.M., Nests and nest accessories. Preprint.

## Instance Data
q
=
Type: Integer
Description: Order of ground field for (q-1)-nest construction; q must be an odd prime power.

b
=
Type: Sequence of integers
Description: The vector representation over the prime field of an element of GF(q) which satisfies: b(b+1) is a nonzero square.

color
=====
Type: Integer
Description: Must be 0 or 1. See notes for details.

### Example
```json
{"q":5,"b":[2],"color":0}
```

## Implementation

### Function

bakerEbertTwoQMinusOneNestImplementation(q,b,color);

### Input

q: integer that is a power of an odd prime, possibly itself a prime
b: sequence of integers representing a field element as above
color: integer that can be 0 or 1

### Output

If successful, a Magma PlaneProj object modeling a 2(q-1)-nest plane of order q^2.

### Notes
The 2(q-1)-nest construction is actually the union of two pairwise disjoint (q-1)-nests. Each of these nests can be replaced in two ways using opposite half-reguli which are orbits under phi^2, where phi is the Bruck kernel map of order q+1 that fixes each line of the base regular spread. Calling the replacements for one of the nests A and A', and the other B and B', it is easy to see that the spread obtained by replacing with A and B is isomorphic to the spread obtained by replacing A' and B', using the map phi as the isomorphism. However, it is not obvious that these spreads are isomorphic to the one obtained by replacing A and B'; indeed when q=7 these spreads are NOT isomorphic, and yield different planes. There is an internal canonical representation of these different replacements which we call red and blue; setting color=0 will use both red replacements, while setting color=1 will use red on one and blue on the other.
