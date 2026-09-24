# Planes from Replacement of Complexes in Replaceable Complexes dataset

## Reference
Dover, J. M. (2026). Replaceable complexes in regular spreads of PG(3,q) for small q: a dataset (Version 1.0.0) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.22928770

## Instance Data
id
==
Type: String
Description: The identifier from the replaceable complexes dataset indicating the complex to be reversed. Format must be "complex-5-#####"; legal values are 00001-00013.

colorSequence
=============
Type: Sequence of integers
Description: Must be a sequence of 0s or 1s of the same length as the complex. Value is ignored for reguli in the complex. For nests in the sequence this provides a canonical method to pick one of the two half-regulus replacements.

### Example
```json
{"id":"complex-5-00013","colorSequence":[0,1]}
```

## Implementation

### Function

rcComplexReplacementImplementation(id,colorSequence);

### Input

id: string as described in the instance data
colorSequence: sequence of integers (0/1) as described in the instance data

### Output

A Magma PlaneProj object modeling the plane obtained by replacing each element of the complex found in the Replaceable Complexes dataset.
