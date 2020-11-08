FROM ubuntu:18.04

# configure timezone
ARG TIMEZONE=Europe/Prague
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

# common devel dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -yqq && \
    apt-get install -yqq \
      build-essential \
      cloc \
      curl \
      default-jdk \
      flex \
      git \
      gfortran \
      jags \
      libavfilter-dev \
      libbz2-dev \
      libcairo2-dev \
      libgit2-dev \
      libcurl4-gnutls-dev \
      libfftw3-dev \
      libgdal-dev \
      libglpk-dev \
      libglu1-mesa-dev \
      libgmp3-dev \
      libgsl-dev \
      libhiredis-dev \
      libjpeg-dev \
      liblzma-dev \
      libmagick++-dev \
      libmysqlclient-dev \
      libmpfr-dev \
      libpcre2-dev \
      libpcre3-dev \
      libpng-dev \
      libpoppler-cpp-dev \
      libpq-dev \
      libreadline-dev \
      librsvg2-dev \
      libsodium-dev \
      libssh2-1-dev \
      libssl-dev \
      libtiff5-dev \
      libudunits2-dev \
      libv8-dev \
      libwebp-dev \
      libxml2-dev \
      locales \
      openjdk-8-jdk \
      procps \
      rsync \
      sudo \
      t1-xfree86-nonfree \
      texlive-latex-extra \
      tzdata \
      tk-dev \
      tree \
      ttf-xfree86-nonfree \
      ttf-xfree86-nonfree-syriac \
      unixodbc-dev \
      vim \
      wget \
      x11-utils \
      xfonts-100dpi \
      xfonts-75dpi \
      xorg-dev \
      xvfb \
      zlib1g-dev

env R_DIR="/R/R-dyntrace" \
    R_KEEP_PKG_SOURCE=1 \
    R_ENABLE_JIT=0 \
    R_COMPILE_PKGS=0 \
    R_DISABLE_BYTECODE=1 \
    OMP_NUM_THREADS=1

# RDT
ARG VERSION=r-4.0.2

RUN git clone https://github.com/PRL-PRG/R-dyntrace "$R_DIR" && \
  cd "$R_DIR" && \
  git checkout "$VERSION" && \
  ./build

env PATH=$R_DIR/bin:$PATH
