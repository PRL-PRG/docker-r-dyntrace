#!/bin/sh

USERID=$(id -u)
GROUPID=$(id -g)

docker run \
       --rm \
       -ti \
       -v r-cran-mirror:/CRAN/src \
       -v r-packages:/R/installed \
       -v r-src-packages:/R/sources \
       -e R_LIBS=/R/installed \
       -e USER=$(id -un) \
       -e GROUP=$(id -gn) \
       -e USERID=$USERID \
       -e GROUPID=$GROUPID \
       -e ROOT="TRUE" \
       prlprg/r-dyntrace \
       "$@"
