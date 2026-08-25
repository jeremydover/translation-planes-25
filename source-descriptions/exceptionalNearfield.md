# Exceptional (Zassenhaus) Nearfield Construction

## Reference
Algebraic structures are due to Zassenhaus:
Zassenhaus, H., Über endliche Fastkörper. Abh. Math. Semin. Univ. Hambg. 11:187-220, 1935.

This version pulls from Dembowski:
Dembowski, Peter. Finite Geometries: Reprint of the 1968 Edition. Germany, Springer Berlin Heidelberg, 1968.

## Instance Data
index
=====
Type: String
Description: A Roman numeral string referring to one of the seven irregular nearfields classified by Zassenhaus.

### Example
```json
{"index":"VII"}
```

## Implementation

### Function

exceptionalNearfieldImplementation(index);

### Input

index: one of the strings "I","II","III","IV","V","VI","VII"

### Output

A Magma PlaneProj object modeling the exceptional nearfield plane associated with an irregular Zassenhaus nearfield.

### Notes