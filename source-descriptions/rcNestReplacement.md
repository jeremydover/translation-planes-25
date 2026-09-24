# Planes from Replacement of Nests in Replaceable Complexes dataset

## Reference
Dover, J. M. (2026). Replaceable complexes in regular spreads of PG(3,q) for small q: a dataset (Version 1.0.0) [Computer software]. Zenodo. https://doi.org/10.5281/zenodo.22928770

## Instance Data
id
==
Type: String
Description: The identifier from the replaceable complexes dataset indicating the nest to be reversed. Format must be "web-5-2-####"; values that correspond to replaceable nests that will give an actual plane are: 0001-0007, 0010-0011, 0013

### Example
```json
{"id":"web-5-2-0001"}
```

## Implementation

### Function

rcNestReplacementImplementation(id);

### Input

id: string as described in the instance data

### Output

A Magma PlaneProj object modeling the plane obtained by replacing the nest found in the Replaceable Complexes dataset.
