# Genealogy of the Translation Planes of Order 25

## Overview

In 1992 Czerwinski and Oakden (The translation planes of order 25, J. Combin. Theory Ser. A, 59:193-217, 1992) provided an exhaustive list of all spreads of PG(3,5) and thus of all translation planes of order 25. At that time, the authors provided a partial correlation with planes then described in the literature, but the intervening years have provided additional construction techniques and classification results. This dataset provides an extensive classification of these planes against currently known construction techniques.

There exist other excellent explications of these data, particularly by Eric Moorhouse (https://ericmoorhouse.org/pub/planes25/), and we have used Moorhouse's site frequently as a check for our data. What distinguishes our approach is this: rather than cataloging planes, we are attempting to catalog and correlate our knowledge of the planes' provenance. In simpler terms, instead of cataloging what planes exist, we are trying to catalog the meta-question of why these planes exist.

Our dataset is arranged around three main data items, planes, sources and models. Planes are exactly that, a simple listing of planes with some of their invariants. Sources are ways in which models for planes can be generated; the obvious interpretation is of construction techniques, but transforms such as dualization and derivation, and exhaustive searches such as Czerwinski and Oakden are also valid sources for modeling planes. Models provide provenance information, tying sources to planes with the instance data needed to actually create the model for the plane from the source.

In addition to data, a significant amount of code is provided which allows the user to re-create our findings. Every source comes with Magma code to instantiate plane models; even references to existing catalogs provide Magma functions to facilitate their implementation. In addition, a test script is provided which verifies all model sources.

Finally, this dataset is a proving ground for the code, techniques, and schema that we hope to use to tackle the much larger problems of organizing knowledge about the translation planes of order 49, and the 2-dimensional translation planes of order 64, both of which have been exhaustively searched.

## Scope

This dataset is limited to the translation planes of order 25. We hope to use the framework presented here to create other datasets of projective planes; however, we have deliberately kept the scope limited for this project in order to produce a publishable artifact early, to invite external validation and constructive criticism before extending this framework to other orders.

## Repository Structure

- `planes.jsonl`
  A plane is (in this dataset) a record of the existence of one of the 21 projective translation planes of order 25. Each plane record contains:
    - An internal identifier
    - The order of the plane
    - A pointer to the data file containing the reference model
    - A list of invariants of the plane

- `sources.jsonl`
  A source is a method or reference which provides a model of a plane. Generically, there are three types of sources:
    - Constructions: mathematical methods that describe how to construct a plane from a set of basic parameters
    - Transforms: methods by which a source plane can be transformed into another plane
    - Catalogs: external enumerations of planes, such as those discovered by computer search

  A source record contains:
    - An internal identifier
	- A type field as discussed above
	- A link to the documentation for the source
	- A link to the implementation code for the source
	
- `models.jsonl`
  A model record ties planes to sources. Each record contains:
    - A plane identifier, indicating which plane is modeled
	- A source identifier, indicating what source technique is being used
	- Source-dependent instance data, which provides the parameters for the source needed to instantiate this specific plane.

- `implementations/`
  Magma implementations of sources represented in the dataset.

- `source-descriptions/`
  Human-readable descriptions of the sources, their parameters, and references.

- `reference-models/`
  Each plane comes with a reference model, which is simply a packed incidence structure giving the lines of the plane as sets of integers from 1 through $q^2+q+1$, where $q$ is the order of the plane. The reference model is important because it provides a fixed description of the plane, so that when specific subsets of points of the plane need to be described (e.g., defining derivation sets), they will be given in context of the reference model without privileging or requiring any particular construction technique.

- `library/`
  The library contains several sets of functions that are useful across multiple sources, e.g. functions for dealing with the Bruck-Bose model for translation planes. In addition, there are library functions which allow the user to load reference models directly in Magma.

- `tests/`
  Automated scripts to validate implementations against reference models.

## Constructions and Provenance

As stated earlier, the goal of this dataset is not to document planes, but to document provenance knowledge about planes. In particular, this means that most planes have more than one source; as they say, this is a feature, not a bug. Our goal with this dataset (which we admittedly have probably not met) is to identify and document every instance where a known construction technique creates a translation plane of order 25. The Czerwinski and Oakden classification ensures that we will not generate any new translation planes. However, in the course of this project we did not find existing constructions for their planes B7 and B8, though we were able to generate a sporadic nest whose replacement did instantiate B7. It is our hope that by cross-correlating as much knowledge about construction techniques against the existing search data for orders 49 and 64, we can identify promising candidates for future constructions of projective planes.

One of the sticky issues with provenance is determining what constitutes "knowledge", and it is best illustrated with derivation. Derivation is a technique which transforms one plane into another, and depends on the existence of a derivation set. One fully legitimate technique to determine derivations is to search each reference model for derivation sets, and document the results. However, many construction techniques have "known" derivations; for example, if one obtains a translation plane by starting with a regular spread and reversing a (q-1)-nest, it is known that the resulting spread contains reguli, which form derivation sets.

Our "solution" to this problem is to simply document both. We accept that there may exist "sporadic" derivation sets in projective planes found by search, and to the extent those are found they absolutely should be documented. However, when an existing construction allows known derivation, we create an additional source that performs that "known" derivation as a separate technique. We believe this allows maximum flexibility, and interestingly, we find that in this dataset all derivations are "known" in this sense.

## Magma Implementations

Implementation code was developed and tested on Magma V2.17-5. Yes, that's super old, but it should work on any more modern version. Each source exposes a function named `<sourceName>Implementation`, which can be used to instantiate the construction of a particular model. Arguments to this function are formatted exactly as they are provided in the model record; note particularly the importance of double quotes around strings. It is possible for constructions to fail; we have attempted to create as many defensive checks to validate the mathematics as possible, and in those cases the Implementation functions will return 0; otherwise they return a Magma projective plane object.

## Validation

The repository includes an automated test harness which, for each record in `models.jsonl`:

1. loads the corresponding construction implementation;
2. constructs the plane from the stored parameters;
3. loads the claimed reference model; and
4. verifies the result using Magma's `IsIsomorphic`.

Make sure to run the validation script from the main directory to ensure relative paths resolve correctly, e.g. `python tests/test_models_py3.py`. A successful test verifies that the stored implementation and instance data produce a plane isomorphic to the reference plane identified by the model record.

## References

Each source comes with one or more references describing the bibliographic source for the construction technique. These are documented in the source description files.

## AI Usage

Generative AI tools, and specifically ChatGPT, were used in the development of this dataset. Specifically, AI was used to:
1. Assist with literature search;
2. Design and templating of data formatting;
3. Format conversion for projective plane reference models;
4. Develop data manipulation code (plane loading) and test harness;
5. Debug mathematical code;
6. Review documentation; and
7. Validate dataset packaging.

AI was NOT used:
1. As a mathematical authority;
2. To develop any source implementation code;
3. To select source techniques; 
4. To create, verify or interpret any model record; or
5. As the final authority for any mathematical or computational verification.

Specifically, no AI-generated claims are reflected in this research without having been independently researched and verified. The contents are the responsibility of the author.

## Contributing / Corrections

Questions, corrections, and contributions are welcome through the GitHub issue tracker at https://github.com/jeremydover/translation-planes-25/issues.

## License

Except where otherwise noted, the contents of this repository are dedicated to the public domain under the Creative Commons CC0 1.0 Universal Public Domain Dedication.
