# André Quasifield Construction

## Reference
André, Johannes, Über nicht-Desarguessche Ebenen mit transitiver Translationsgruppe. Math. Z., 60:156-186, 1954.

## Instance Data
q
=
Type: Integer
Description: Order of ground field for André quasifield construction.

d
=
Type: Integer
Description: Constructed dimension of the André quasifield over its kernel. Actual dimension may be smaller depending on other choices.

automorphismSequence
====================
Type: Sequence of q-2 integers, each between 0 and d-1, inclusive
Description: The integer x in position i of this sequence (1-based indices) indicates the quasifield multiplication a*b = a^{q^x}b for all b with Norm(w^i), where w is a primitive element of GF(q). In particular, the identity automorphism is represented by 0.

### Example
```json
{"q":5,"d":2,"automorphismSequence":[0,1,0]}
```

## Implementation

### Function

andreImplementation(q,d,automorphismSequence);

### Input

q: integer that is a power of a prime, possibly itself a prime
d: positive integer greater than 1
automorphismSequence: sequence of q-2 integers, each between 0 and d-1, inclusive

### Output

A Magma PlaneProj object modeling the André plane of order q^d defined by the given automorphism sequence.

### Notes