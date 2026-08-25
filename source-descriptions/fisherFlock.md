# Fisher Flock/q-nest Construction

## Reference
Fisher Flocks
=============
Fisher, J.C., Geometry according to Euclid. Amer. Math Monthly 86:260-270, 1979.

q-nests
=======
Baker, R.D. and Ebert, G.L, A new class of translation planes. Ann. Discrete Math. 37:7–20, 1988.

Payne proved that these two constructions yield the same planes:
Payne S.E., Spreads, flocks and generalized quadrangles. J. Geom. 33:113-128, 1988.

## Instance Data
q
=
Type: Integer
Description: Order of ground field for q-nest construction; q must be an odd prime power.

### Example
```json
{"q":5}
```

## Implementation

### Function

fisherFlockImplementation(q);

### Input

q: integer that is a power of an odd prime, possibly itself a prime

### Output

If successful, a Magma PlaneProj object modeling the Fisher Flock/q-nest plane of order q^2.

### Notes
