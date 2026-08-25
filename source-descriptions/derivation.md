# Derivation

## Reference
Ostrom, T.G., Translation planes and configurations in Desarguesian planes. Arch. Math. 11:457-464, 1960.

## Instance Data
sourcePlane
===========
Type: String
Description: The identifier of the plane which is being derived. This is the id field for the corresponding plane in the planes.jsonl data file.

derivationSet
=============
Type: Sequence of integers
Description: A sequence of point labels in the reference model which comprises a derivation set.

### Example
```json
{"sourcePlane":"pp25-s2","derivationSet":[626,627,628,629,630,631]}
```

## Implementation

### Function
derivationImplementation(sourcePlane,derivationSet);

### Input
sourcePlane: string identifying the plane in the database
derivationSet: Sequence of integers representing points in the reference model (1-based)

### Output
A Magma PlaneProj object modeling the derived plane, specifically a Magma PlaneProj object

### Notes
