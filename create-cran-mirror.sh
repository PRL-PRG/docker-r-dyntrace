#!/bin/sh

# rsync compatible CRAN mirror
MIRROR=${MIRROR:-"cran.r-project.org"}

docker run \
       --rm \
       -ti \
       -v r-cran-mirror:/CRAN/src \
       prlprg/r-dyntrace \
       rsync \
       -rtlzv \
       --delete \
       --include="*.tar.gz" \
       --include="PACKAGES*" \
       --exclude="*/*" \
       "$MIRROR::CRAN/src/contrib/" /CRAN/src/contrib
