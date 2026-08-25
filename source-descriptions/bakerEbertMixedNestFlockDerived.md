# Mixed Nest Construction - Flock Derivation

## Reference
Baker, R.D. and Ebert, G.L., Filling the nest gaps. Finite Fields Appl. 2:42–61, 1996.

## Instance Data
q
=
Type: Integer
Description: Order of ground field for the mixed nest construction; q must be an odd prime power.

c
=
Type: Sequence of integers
Description: The vector representation over the prime field of an element of GF(q) such that c+1 is a non-square in GF(q).

reguli
======
Type: Sequence of integers
Description: A sequence containing the concatenated vector representations of elements of GF(q) over the prime field such that for each field element a in the sequence the corresponding circle {x:N(x) = a} is disjoint from the constructed nest. This occurs when (ac-1)^2-4a is a square in GF(q). These are the reguli that will be reversed in addition to the nest being reversed.

### Example
```json
{"q":5,"c":[1],"reguli":[1]}
```

## Implementation

### Function

bakerEbertMixedNestFlockDerivedImplementation(q,c,reguli);

### Input

q: integer that is a power of an odd prime, possibly itself a prime
c: sequence of integers representing a field element as above
reguli: a sequence of integers representing one or more field elements as above

### Output

If successful, a Magma PlaneProj object modeling a mixed nest plane of order q^2 which has been derived with respect to the reguli given.

### Notes