FROM ubuntu

RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    build-essential \
    cloc \
    curl \
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

RUN locale-gen en_US.UTF-8

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

LABEL maintainer "krikava@gmail.com"

CMD ["R"]
