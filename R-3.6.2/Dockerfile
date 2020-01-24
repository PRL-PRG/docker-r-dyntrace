FROM ubuntu:18.04

RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    build-essential \
    cloc \
    curl \
    fish \
    gfortran \
    git \
    libbz2-dev \
    libcurl4-gnutls-dev \
    libgit2-dev \
    libjpeg-dev \
    liblzma-dev \
    libmariadb-client-lgpl-dev \
    libpcre3-dev \
    libpng-dev \
    libreadline-dev \
    libssh2-1-dev \
    libssl-dev \
    libtiff5-dev \
    libxml2-dev \
    locales \
    openjdk-8-jdk \
    procps \
    rsync \
    sudo \
    texlive \
    tzdata \
    vim \
    wget \
    xvfb \
    zlib1g-dev \
    zsh

# install latest GNU parallel (ubuntu has an old version)
RUN curl -L https://bit.ly/install-gnu-parallel-2 | sh -x
RUN locale-gen en_US.UTF-8

# install latest GNU R
ARG CFLAGS=""
ARG CONFIGURE_OPTS=""
ARG MAKE_OPTS="-j8"
RUN curl https://cloud.r-project.org/src/base/R-3/R-3.6.2.tar.gz | tar -xzf - && \
	  mv R-3.6.2 R && \
		cd /R && CFLAGS=$CFLAGS ./configure --prefix=/usr/local $CONFIGURE_OPTS && \
    make $MAKE_OPTS && \
    make $MAKE_OPTS install

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

LABEL maintainer "krikava@gmail.com"

CMD ["R"]
