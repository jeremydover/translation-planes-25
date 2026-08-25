# Dickson Nearfield Construction

## Reference
Algebraic structures are due to Dickson:
Dickson, Leonard E., On finite algebras. Nachr. kgl. Ges. Wiss. Göttingen, 358-393, 1905. 

This version pulls from Dembowski:
Dembowski, Peter. Finite Geometries: Reprint of the 1968 Edition. Germany, Springer Berlin Heidelberg, 1968.

## Instance Data
q
=
Type: Integer
Description: Prime power, possibly itself a prime

n
=
Type: Integer
Description: All of this number's prime divisors must divide q-1, and if q = 3 (mod 4), n is not divisible by 4. The resulting nearfield will have size q^n.

### Example
```json
{"q":5,"n":2}
```

## Implementation

### Function

dicksonNearfieldImplementation(q,n);

### Input

q: integer that is a power of a prime, possibly itself a prime
n: degree of extension field to modify to create nearfield

### Output

A Magma PlaneProj object modeling the Dickson nearfield plane of order q^n.

### Notes