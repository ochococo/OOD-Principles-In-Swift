#!/bin/bash

# remove the old .playground
rm -R ./OOD-Principles-In-Swift.playground

cat ./docs/header.md > ./README.md

cat ./docs/srp.md >> ./README.md
cat ./docs/ocp.md >> ./README.md
cat ./docs/lsp.md >> ./README.md
cat ./docs/isp.md >> ./README.md
cat ./docs/dip.md >> ./README.md

cat ./docs/footer.md >> ./README.md

# see (https://www.npmjs.org/package/playground) to understand playground executable
playground ./README.md --platform ios --stylesheet ./stylesheet.css

# rename readme for new playground
mv ./README.playground ./OOD-Principles-In-Swift.playground

zip -r -X OOD-Principles-In-Swift.playground.zip ./OOD-Principles-In-Swift.playground

rm -R ./OOD-Principles-In-Swift.playground

# no playground?
#
# brew install node
# npm install -g playground
