# Fisher Flock/q-nest Construction - Replacement Derivation

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


### Example
```json
{"q":5}
```

## Implementation

### Function

fisherFlockReplacementDerivedImplementation(q);

### Input

q: integer that is a power of an odd prime, possibly itself a prime

### Output

If successful, a Magma PlaneProj object modeling the Fisher Flock/q-nest plane of order q^2 derived with respect to a regulus from the replacement set (plus l_infinity).

### Notes
It is known that the spread corresponding to these constructions admits a conical cover, i.e. a set of q reguli in the spread all of which contain a fixed line. Some of these are obtained from lines of the nest replacement (plus l_infinity), which this construction models. Note that all of these reguli are in a single orbit, so there is no parameter to pick.