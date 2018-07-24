#!/bin/sh

# rsync compatible CRAN mirror
MIRROR=${MIRROR:-"cran.r-project.org"}

docker run \
       --rm \
       -ti \
       -v r-cran-mirror:/CRAN/src \
       -v r-packages:/R/installed \
       -v r-src-packages:/R/sources \
       -e R_LIBS=/R/installed \
       prlprg/r-dyntrace \
       "$@"
