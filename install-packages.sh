#!/bin/sh -x

set -e

# location where to install packages (lib parameter to install.packages)
BIN_TARGET=${BIN_TARGET:-"/R/installed"}
# location where to keep the sources (destdir parameter to install.packages)
SRC_TARGET=${SRC_TARGET:-"/R/sources"}
# a mirror to use e.g. https://cloud.r-project.org
REPO=${REPO:-"file:///CRAN"}
# packages to install as R string vector
PACKAGES=${PACKAGES:-"available.packages()[,1]"}
# addtional args for install.packages -- must start with a ','
INSTALL_ARGS=${INSTALL_ARGS:-", dependencies=TRUE, destdir='$SRC_TARGET', INSTALL_opts=c('--example', '--install-tests', '--with-keep.source', '--no-multiarch'), Ncpus=parallel::detectCores()"}

# install packages
docker run \
       --rm \
       -ti \
       -v r-cran-mirror:/CRAN/src \
       -v r-packages:"$BIN_TARGET" \
       -v r-src-packages:"$SRC_TARGET" \
       prlprg/r-dyntrace \
       Rscript \
       -e \
       "options(repos='$REPO'); install.packages($PACKAGES, lib='$BIN_TARGET'$INSTALL_ARGS)"

# extract downloaded sources
#find -name "$SRC_TARGET/*.tar.gz" -exec tar -C "$SRC_TARGET" -xzf {} \;
#rm -fr "$SRC_TARGET/*.tar.gz"
