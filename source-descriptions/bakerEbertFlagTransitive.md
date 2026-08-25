# Baker-Ebert Flag Transitive Plane Construction

## Reference
Baker, R.D. and Ebert, G.L., Construction of two-dimensional flag transitive planes. Geom. Dedicata, 27:9-14, 1988.

## Instance Data
q
=
Type: Integer
Description: Order of ground field for flag-transitive construction; q must be an odd prime power.

s
=
Type: Integer
Description: s is an odd integer between 1 and q^2, inclusive, that defines the line whose orbit under and appropriate subgroup of the Singer group defines a half-spread of PG(3,q).

r
=
Type: Integer
Description: An integer that translates the half-spread defined by s onto a complementary half-spread that fills the remainder of the space.

### Example
```json
{"q":5,"s":1,"r":3}
```

## Implementation

### Function

bakerEbertFlagTransitiveImplementation(q,s,r);

### Input

q: integer that is a power of an odd prime, possibly itself a prime
s: odd integer between 1 and q^2, inclusive
r: integer

### Output

If successful, a Magma PlaneProj object modeling the a flag-transitive plane of order q^2.

### Notes
Not all combinations of s and r will actually create a full spread. The Baker-Ebert construction guarantees that some r exists for any given s, but is not constructive.