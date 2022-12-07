### The data resources are found in the data/ directory - `R1.n3` with information about Alice using the FOAF ontology - `R2.n3` with an address book of Alice - `R3.n3` with information about her romantic partner Bob using the VCARD ontology ### Context provides the context of the user who wants to access the knowledge base - `context/Context.n3` provides an example how to define a Public and Friend context ### Query are documents that filter out the fields to show from the results - `query/Query.n3` is a query some user could have done ### Policies define how data should be managed. We define distinct policies for different steps of the data reasoning process. #### Data mapping policies These policies are stored in the `policies/mapping_policies/` directory. - `VCardFoafPolicy.n3` defines a mapping between some VCARD and FOAF properties. #### Data categorizing policies These policies are stored in the `policies/category_policies/` directory. #### Data access policies These policies are stored in the `policies/access_policies/` directory. - `Policy1.n3` states that a public context can only see the foaf:name and foaf:email - `Policy2.n3` states that a friend can see all personal information - `Policy3.n3` states that a warning should be provided when emails get exposed ### Running the policy chain These policies form a chain of logic operations on the data. Every execution of a set of policies results can result in any set of surfaces being defined by these policies. We define the following mapping for now:Mapping policy execution:base surface => base surface Categorizing policy execution:base surface => base surface Data Access Policies:base surface => result surface, warning surface, error surface ### Run example #### Run data mapping step ```bash eye --nope --quiet --blogic data
/*.n3  query/*.n3 policies/mapping_policies/*.n3 > mappingQuerySurface.n3
```

The resulting file `mappingQuerySurface.n3` provides the resulting surface from the data mapping step

#### Run category mapping step

```bash
eye --nope --quiet --blogic mappingQuerySurface.n3 policies/category_policies/*.n3 > categoryQuerySurface.n3
```

The resulting file `categoryQuerySurface.n3` provides the resulting surface from the data categorizing step

#### Run data access step

```bash
eye --nope --quiet --blogic categoryQuerySurface.n3 context/*.n3 policies/access_policies/*.n3 > dataAccessQuerySurface.n3
```


### Output public accesss

```
@prefix : <urn:example:>.
@prefix log: <http://www.w3.org/2000/10/swap/log#>.
@prefix foaf: <http://xmlns.com/foaf/0.1/>.


() log:onResultSurface {<urn:example:Person1> foaf:name "Alice". <<<urn:example:Person1> foaf:name "Alice">> log:ohyeah <urn:example:Policy_1>. <urn:example:Person1> foaf:email <mail:alice@somewhere.org>. <<<urn:example:Person1> foaf:email <mail:alice@somewhere.org>>> log:ohyeah <urn:example:Policy_1>}.
() log:onResultSurface {<urn:example:Person2> foaf:name "Bob". <<<urn:example:Person2> foaf:name "Bob">> log:ohyeah <urn:example:Policy_1>. <urn:example:Person2> foaf:email <mail:bob@somewhere.org>. <<<urn:example:Person2> foaf:email <mail:bob@somewhere.org>>> log:ohyeah <urn:example:Policy_1>}.
() log:onWarningSurface {<urn:example:Person1> foaf:email <mail:alice@somewhere.org>. <<<urn:example:Person1> foaf:email <mail:alice@somewhere.org>>> a log:WARNING. <<<urn:example:Person1> foaf:email <mail:alice@somewhere.org>>> log:warningMessage "You are exposing email addresses as public access!"}.
() log:onWarningSurface {<urn:example:Person2> foaf:email <mail:bob@somewhere.org>. <<<urn:example:Person2> foaf:email <mail:bob@somewhere.org>>> a log:WARNING. <<<urn:example:Person2> foaf:email <mail:bob@somewhere.org>>> log:warningMessage "You are exposing email addresses as public access!"}.
```

### Output friend access

```
@prefix : <urn:example:>.
@prefix log: <http://www.w3.org/2000/10/swap/log#>.
@prefix foaf: <http://xmlns.com/foaf/0.1/>.

() log:onResultSurface {<urn:example:Person1> a foaf:Person. <<<urn:example:Person1> a foaf:Person>> log:ohyeah <urn:example:Policy_2>}.
() log:onResultSurface {<urn:example:Person1> foaf:name "Alice". <<<urn:example:Person1> foaf:name "Alice">> log:ohyeah <urn:example:Policy_2>}.
() log:onResultSurface {<urn:example:Person1> foaf:telephone <urn:tel:0012-1219-212-121>. <<<urn:example:Person1> foaf:telephone <urn:tel:0012-1219-212-121>>> log:ohyeah <urn:example:Policy_2>}.
() log:onResultSurface {<urn:example:Person1> foaf:email <mail:alice@somewhere.org>. <<<urn:example:Person1> foaf:email <mail:alice@somewhere.org>>> log:ohyeah <urn:example:Policy_2>}.
() log:onResultSurface {<urn:example:Person1> foaf:address <urn:example:Address1>. <<<urn:example:Person1> foaf:address <urn:example:Address1>>> log:ohyeah <urn:example:Policy_2>}.
() log:onResultSurface {<urn:example:Person1> <urn:example:inLoveWith> <urn:example:Person2>. <<<urn:example:Person1> <urn:example:inLoveWith> <urn:example:Person2>>> log:ohyeah <urn:example:Policy_2>}.
() log:onResultSurface {<urn:example:Person2> a foaf:Person. <<<urn:example:Person2> a foaf:Person>> log:ohyeah <urn:example:Policy_2>}.
() log:onResultSurface {<urn:example:Person2> foaf:name "Bob". <<<urn:example:Person2> foaf:name "Bob">> log:ohyeah <urn:example:Policy_2>}.
() log:onResultSurface {<urn:example:Person2> foaf:telephone <urn:tel:0213-3123-1231>. <<<urn:example:Person2> foaf:telephone <urn:tel:0213-3123-1231>>> log:ohyeah <urn:example:Policy_2>}.
() log:onResultSurface {<urn:example:Person2> foaf:email <mail:bob@somewhere.org>. <<<urn:example:Person2> foaf:email <mail:bob@somewhere.org>>> log:ohyeah <urn:example:Policy_2>}.
```












### mapping

eye --nope --quiet --blogic  ./data/*.n3 ./operations/mapping/*.n3 ./query/OnlyDataQuery.n3 > ./output/intermediate/mappingoutput.n3


### categorizing

eye --nope --quiet --blogic  ./output/intermediate/mappingoutput.n3 ./operations/categorizing/*.n3 ./query/OnlyDataQuery.n3 > ./output/intermediate/categoryoutput.n3


### data access

eye --nope --quiet --blogic  ./output/intermediate/categoryoutput.n3 ./context/*.n3  ./operations/access/*.n3 ./query/ResultQuery.n3 > ./output/intermediate/access.n3

### processing result

**view results**

eye --nope --quiet --blogic  ./output/intermediate/access.n3 ./query/convertResults.n3 > ./output/results/data.n3

**view warnings**

eye --nope --quiet --blogic  ./output/intermediate/access.n3 ./query/convertWarnings.n3 > ./output/results/warnings.n3

**view metadata**

eye --nope --quiet --blogic  ./output/intermediate/access.n3 ./query/convertMetadata.n3 > ./output/results/metadata.n3