#!/bin/sh -eux

apt-get update
apt-get full-upgrade -y --no-install-recommends
apt-get install -y --no-install-recommends \
    apt-utils \
    autoconf \
    automake \
    bison \
    check \
    clang \
    cmake \
    file \
    flex \
    g++ \
    gcc \
    git \
    gnutls-dev \
    libc-dev \
    libcjson-dev \
    libfltk1.3-dev \
    libgcrypt20-dev \
    libjansson-dev \
    libjpeg-dev \
    libjson-c-dev \
    liblmdb-dev \
    libpcre2-dev \
    libpcre3-dev \
    libpng-dev \
    libssl-dev \
    libsubunit-dev \
    libtalloc-dev \
    libtool \
    libyaml-dev \
    make \
    pkg-config \
    python2 \
    python3 \
    zlib1g-dev \
;
