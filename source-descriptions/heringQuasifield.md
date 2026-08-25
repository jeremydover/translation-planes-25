# Hering Quasifield Construction

## Reference
Hering, C. A new class of quasifields. Math. Z., 118:56–57, 1970.

## Instance Data
q
=
Type: Integer
Description: Order of ground field for Hering quasifield construction. This must be a prime power equivalent to 5 (mod 6).

### Example
```json
{"q":5}
```

## Implementation

### Function
heringQuasifieldImplementation(q);

### Input
q: integer that is a power of a prime, possibly itself a prime. q must be equivalent to 5 (mod 6).

### Output
A Magma PlaneProj object modeling the Hering quasifield plane of order q^2, specifically a Magma PlaneProj object

### Notes