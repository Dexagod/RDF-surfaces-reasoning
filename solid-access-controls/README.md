# Reasoning demonstration for RDF + Surfaces in the Solid access controls use-case

## steps:

This demonstrator incorporates the following steps:


### Data mapping
This step maps predicates from the FOAF and VCard ontologies to each other.

### Categorization
The categorization step maps all triples in the data to a category defined by the closest linked subject that has an `rdf:type`.
(This step also adds a `example:statedBy` triple, to demonstrate the possibility of adding provenance for triples)

### Data access
The data access step evaluates policies for data access on the result of the previous steps.



## Execution

Execution can be done at once using the following command:

```
bash run.sh
```

Note: you need to have the EYE reasoner available on the ```eye``` command.

The individual steps can also be run as follows:
### mapping
```
eye --nope --quiet --blogic  ./data/*.n3 ./operations/mapping/*.n3 ./query/OnlyDataQuery.n3 > ./output/intermediate/mappingoutput.n3
```

### categorizing
```
eye --nope --quiet --blogic  ./output/intermediate/mappingoutput.n3 ./operations/categorizing/*.n3 ./query/OnlyDataQuery.n3 > ./output/intermediate/categoryoutput.n3
```

### data access
```
eye --nope --quiet --blogic  ./output/intermediate/categoryoutput.n3 ./context/*.n3  ./operations/access/*.n3 ./query/ResultQuery.n3 > ./output/intermediate/access.n3
```

### processing result

**view results**
```
eye --nope --quiet --blogic  ./output/intermediate/access.n3 ./query/convertResults.n3 > ./output/results/data.n3
cat ./output/results/data.n3
```
**view warnings**
```
eye --nope --quiet --blogic  ./output/intermediate/access.n3 ./query/convertWarnings.n3 > ./output/results/warnings.n3
cat ./output/results/warnings.n3
```

**view metadata**
```
eye --nope --quiet --blogic  ./output/intermediate/access.n3 ./query/convertMetadata.n3 > ./output/results/metadata.n3
cat ./output/results/metadata.n3
```