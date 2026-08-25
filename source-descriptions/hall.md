# Hall Quasifield Construction

## Reference
Original construction is due to Hall:
Hall, Marshall, Projective planes. Trans. Amer. Math. Soc., 54:229-277, 1943.

This version pulls from Dembowski:
Dembowski, Peter. Finite Geometries: Reprint of the 1968 Edition. Germany, Springer Berlin Heidelberg, 1968.

## Instance Data
q
=
Type: Integer
Description: Order of ground field for Hall quasifield construction.

### Example
```json
{"q":5}
```

## Implementation

### Function
hallImplementation(q);

### Input
q: integer that is a power of a prime, possibly itself a prime

### Output
A Magma PlaneProj object modeling the Hall plane of order q^2, specifically a Magma PlaneProj object

### Notes
The Hall plane construction requires an irreducible polynomial of degree 2; the reference implementation uses Magma's canonical degree 2 field extension via Conway polynomials to select such a polynomial. The planes constructed are isomorphic regardless of the polynomial used.