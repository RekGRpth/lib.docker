#!/bin/sh -eux

apk update --no-cache
apk upgrade --no-cache
apk add --no-cache --virtual .build-deps \
    autoconf \
    automake \
    bison \
    check-dev \
    cjson-dev \
    clang \
    cmake \
    file \
    flex \
    fltk-dev \
    g++ \
    gcc \
    git \
    gnutls-dev \
    jansson-dev \
    jpeg-dev \
    json-c-dev \
    libgcrypt-dev \
    libpng-dev \
    libtool \
    linux-headers \
    lmdb-dev \
    make \
    musl-dev \
    openssl-dev \
    pcre2-dev \
    pcre-dev \
    python2 \
    subunit-dev \
    talloc-dev \
    yaml-dev \
    zlib-dev \
;
