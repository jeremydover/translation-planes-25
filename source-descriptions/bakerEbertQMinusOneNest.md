# (q-1)-nest Construction

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

### Example
```json
{"q":5,"b":[2]}
```

## Implementation

### Function

bakerEbertQMinusOneNestImplementation(q,b);

### Input

q: integer that is a power of an odd prime, possibly itself a prime
b: sequence of integers representing a field element as above

### Output

If successful, a Magma PlaneProj object modeling a (q-1)-nest plane of order q^2.

### Notes
