#!/bin/sh

set -e

./run.sh Rscript -e "x <- installed.packages('/R/installed'); writeLines(file.path('/CRAN/src/contrib', paste0(x[,1], '_', x[,3], '.tar.gz')), '/R/sources/archives.txt')"
./run.sh parallel --workdir /R/sources --bar -a /R/sources/archives.txt tar xfv '{}'
./run.sh rm /R/sources/archives.txt
