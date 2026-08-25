# F-Fibrations

## Reference
Baker, R.D., Dover, J.M., Ebert, G.L., and Wantz K.L., Hyperbolic fibrations in PG(3,q). Europ. J. Combin. 20:1–16, 1999.

## Instance Data
q
=
Type: Integer
Description: Order of ground field for F-fibration construction; q must be an odd prime power.

reguli
======
Type: Sequence of integers
Description: This sequence indicates which regulus we should pick from each quadric in the hyperbolic fibration. The ordering of the quadrics in the fibration is fixed within the construction, and the two reguli in each quadric are constructed in a deterministic manner. Thus, this sequence merely needs to pick 0 or 1 for each regulus to pick which of the reguli to use, so a valid sequence is exactly a sequence of q-1 0s and 1s.

### Example
```json
{"q":5,"reguli":[1,0,0,1]}
```

## Implementation

### Function

fHyperbolicFibrationImplementation(q,reguli);

### Input

q: integer that is a power of an odd prime, possibly itself a prime
reguli: a sequence of q-1 0/1 integers indicating which regulus should be picked from each quadric

### Output

If successful, a Magma PlaneProj object modeling a plane spawned from the F-fibration of Baker et al.

### Notes
When q=5, the construction does give a hyperbolic fibration, but it yields the same planes as the H-fibration.