# J0-Fibrations

## Reference
Johnson, N.L., Pomareda, R., and Wilke, F.W., j-Planes. J. Combin. Theory Ser. A 56:271-284, 1991.

Our computations use the simpler algebraic descriptions in:
Baker, R.D., Ebert, G.L., and Wantz, K.L., Regular hyperbolic fibrations. Adv. Geom. 1:119-144, 2001.

## Instance Data
q
=
Type: Integer
Description: Order of ground field for J0-fibration construction; q must be an odd prime power.

i
=
Type: Integer
Description: Index for field automorphism used in construction. Must be between 0 and e, where q=p^e for some prime p.

reguli
======
Type: Sequence of integers
Description: This sequence indicates which regulus we should pick from each quadric in the hyperbolic fibration. The ordering of the quadrics in the fibration is fixed within the construction, and the two reguli in each quadric are constructed in a deterministic manner. Thus, this sequence merely needs to pick 0 or 1 for each regulus to pick which of the reguli to use, so a valid sequence is exactly a sequence of q-1 0s and 1s.

### Example
```json
{"q":9,"i":1,"reguli":[1,0,0,1,0,1,1,1]}
```

## Implementation

### Function

j0HyperbolicFibrationImplementation(q,i,reguli);

### Input

q: integer that is a power of an odd prime, possibly itself a prime
i: integer as described above
reguli: a sequence of q-1 0/1 integers indicating which regulus should be picked from each quadric

### Output

If successful, a Magma PlaneProj object modeling a plane spawned from the J0-fibration as described in Baker et al.

### Notes
Note: When i=0 or e, the resulting hyperbolic fibration is isomorphic to the fibration which spawns the Andre planes. Thus, this construction does not provide any new information for the case q=5.