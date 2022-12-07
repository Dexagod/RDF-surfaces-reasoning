rm -r ./output/

mkdir ./output/
mkdir ./output/intermediate/
mkdir ./output/results/

echo "Mapping stage"
eye --nope --quiet --blogic  ./data/*.n3 ./operations/mapping/*.n3 ./query/OnlyDataQuery.n3 > ./output/intermediate/mappingoutput.n3

echo "Categorizing stage"
eye --nope --quiet --blogic  ./output/intermediate/mappingoutput.n3 ./operations/categorizing/*.n3 ./query/OnlyDataQuery.n3 > ./output/intermediate/categoryoutput.n3

echo "Data access stage"
eye --nope --quiet --blogic  ./output/intermediate/categoryoutput.n3 ./context/*.n3  ./operations/access/*.n3 ./query/ResultQuery.n3 > ./output/intermediate/access.n3

echo "Splitting results"
eye --nope --quiet --blogic  ./output/intermediate/access.n3 ./query/convertResults.n3 > ./output/results/data.n3

echo "Splitting warnings"

eye --nope --quiet --blogic  ./output/intermediate/access.n3 ./query/convertWarnings.n3 > ./output/results/warnings.n3

echo "Splitting metadata"

eye --nope --quiet --blogic  ./output/intermediate/access.n3 ./query/convertMetadata.n3 > ./output/results/metadata.n3

echo "Results:"
cat ./output/results/data.n3

echo "Warnings:"
cat ./output/results/warnings.n3

echo "Metadata:"
cat ./output/results/metadata.n3