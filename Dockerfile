FROM ubuntu:20.04

# configure timezone
ARG TZ=Europe/Prague

# common devel dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update -yqq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
      build-essential \
      cloc \
      curl \
      default-jdk \
      flex \
      gdb \
      gfortran \
      git \
      jags \
      libavfilter-dev \
      libbz2-dev \
      libcairo2-dev \
      libcurl4-gnutls-dev \
      libfftw3-dev \
      libfribidi-dev \
      libgdal-dev \
      libgit2-dev \
      libglpk-dev \
      libglu1-mesa-dev \
      libgmp3-dev \
      libgsl-dev \
      libharfbuzz-dev \
      libhiredis-dev \
      libjpeg-dev \
      liblzma-dev \
      libmagick++-dev \
      libmpfr-dev \
      libmysqlclient-dev \
      libnlopt-dev \
      libopenblas-dev \
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
      libzmq3-dev \
      locales \
      openjdk-8-jdk \
      pandoc \
      procps \
      rr \
      rsync \
      sudo \
      t1-xfree86-nonfree \
      texlive-latex-extra \
      tk-dev \
      tree \
      ttf-xfree86-nonfree \
      ttf-xfree86-nonfree-syriac \
      tzdata \
      unixodbc-dev \
      vim \
      wget \
      x11-utils \
      xfonts-100dpi \
      xfonts-75dpi \
      xorg-dev \
      xvfb \
      zlib1g-dev

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure --frontend=noninteractive tzdata

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV R_DIR="/R/R-dyntrace" \
    R_KEEP_PKG_SOURCE=1 \
    R_ENABLE_JIT=0 \
    R_COMPILE_PKGS=0 \
    R_DISABLE_BYTECODE=1 \
    OMP_NUM_THREADS=1 \
    LANG=en_US.UTF-8 \
    TZ=$TZ

# RDT
ARG VERSION=r-4.0.2

RUN git clone https://github.com/PRL-PRG/R-dyntrace "$R_DIR" && \
  cd "$R_DIR" && \
  git checkout "$VERSION" && \
  ./build

ENV PATH=$R_DIR/bin:$PATH
