# Fisher Flock/q-nest Construction - Pencil Derivation

## Reference
Fisher Flocks
=============
Fisher, J.C., Geometry according to Euclid. Amer. Math Monthly 86:260-270, 1979.

q-nests
=======
Baker, R.D. and Ebert, G.L, A new class of translation planes. Ann. Discrete Math. 37:7–20, 1988.

## Instance Data
q
=
Type: Integer
Description: Order of ground field for q-nest construction; q must be an odd prime power.

a
=
Type: Sequence of integers
Description: The vector representation over the prime field of an element of GF(q), which describes a circle of the underlying pencil (in q-nest terms) which is disjoint from the nest.

### Example
```json
{"q":5,"a":[2]}
```

## Implementation

### Function

fisherFlockPencilDerivedImplementation(q,a);

### Input

q: integer that is a power of an odd prime, possibly itself a prime
a: sequence of integers selecting a circle which corresponds to a reversable regulus

### Output

If successful, a Magma PlaneProj object modeling the Fisher Flock/q-nest plane of order q^2 derived with respect to a regulus in the pencil of the regular spread from which the q-nest was reversed.

### Notes
It is known that the spread corresponding to these constructions admits a conical cover, i.e. a set of q reguli in the spread all of which contain a fixed line. Some of these are inherited from the regular spread where the q-nest originated, and it is these that are reversed here.