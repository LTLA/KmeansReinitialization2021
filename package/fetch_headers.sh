#!/bin/bash

if [ ! -e _cpp ]
then
    git clone https://github.com/LTLA/CppKmeans _cpp
fi

# Transferring header files.
cd _cpp
git checkout b6dbb52353c5d2a2ffaa94ecaf3a811bf4480b31
cp -r include/kmeans ../inst/include

# Fetching dependencies.
cmake -B build -S .
cp -r build/_deps/aarand-src/include/aarand ../inst/include

# Committing everything.
cd ..
git add inst/include/kmeans
git add inst/include/aarand
