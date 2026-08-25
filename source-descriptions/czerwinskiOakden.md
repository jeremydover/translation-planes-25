# Planes from Czerwinski and Oakden's search

## Reference
T. Czerwinski and D. Oakden. The translation planes of order twenty-five. J. Combin. Theory Ser. A, 59:193–217, 1992.

## Instance Data
label
=====
Type: String
Description: The label from Czerwinski and Oakden's paper identifying the planes in their catalog. Each label is a single capital letter (S,A,B) followed by a single digit. Allowable values are:
S: 1,2,3,4,5
A: 1,2,3,4,5,6,7,8
B: 1,2,3,4,5,6,7,8

### Example
```json
{"label":"A3"}
```

## Implementation

### Function

czerwinskiOakdenImplementation(label);

### Input

label: string as described in the instance data

### Output

A Magma PlaneProj object modeling the plane found by Czerwinski and Oakden in their search.

### Notes
Mechanically, Czerwinski and Oakden report their planes using spread sets of matrices. Our implementation records the spread sets, and creates the plane from there.