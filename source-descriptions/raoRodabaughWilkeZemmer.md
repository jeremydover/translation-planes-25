# Rao Rodabaugh Wilke Zemmer Construction

## Reference
M.J.N. Rao, D.J. Rodabaugh, F.W. Wilke and J.L. Zemmer. A new class of finite translation planes obtained from the exceptional near-fields. J. Combin. Theory Ser. A, 11:72–92, 1971.

## Instance Data
index
=====
Type: String
Description: A Roman numeral string referring to one of the irregular nearfields classified by Zassenhaus which permits this construction. Permissible values are "I", "II", "III", "V", "VI".

subindex
========
Type: Integer
Description: Index into the entries given in the original paper. Permissible values are:
	When index is I: 1,2
	When index is II: 1
	When index is III: 1,3,4
	When index is V: 1,2
	When index is VI: 1

### Example
```json
{"index":"III","subindex":4}
```

## Implementation

### Function

raoRodabaughWilkeZemmerImplementation(index,subindex);

### Input

index: one of the strings "I","II","III","V","VI"
subindex: an integer constrained as in the instance data above

### Output

A Magma PlaneProj object modeling the C-system plane derived from an exceptional nearfield plane.

### Notes