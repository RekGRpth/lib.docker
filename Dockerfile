FROM rekgrpth/gost
RUN set -ex \
    && apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        brotli-dev \
        clang \
        dev86 \
        file \
        fontconfig-dev \
        freetype-dev \
        g++ \
        gcc \
        gettext-dev \
        git \
        jpeg-dev \
        libgcrypt-dev \
        libidn-dev \
        libpng-dev \
        libpsl-dev \
        libssh-dev \
        libtool \
        linux-headers \
        make \
        mt-st \
        musl-dev \
        nghttp2-dev \
        openjpeg-dev \
        openldap-dev \
        openssl-dev \
        zlib-dev \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone --recursive https://github.com/RekGRpth/curl.git \
    && git clone --recursive https://github.com/RekGRpth/htmldoc.git \
    && cd /usr/src/curl \
    && autoreconf -vif \
    && ./configure \
        --enable-ipv6 \
        --enable-ldap \
        --enable-unix-sockets \
        --with-libssh \
        --with-nghttp2 \
    && make -j"$(nproc)" curl-config install \
    && cd /usr/src/curl/include \
    && make -j"$(nproc)" install \
    && cd /usr/src/curl/lib \
    && make -j"$(nproc)" install \
    && cd /usr/src/htmldoc \
    && ./configure --without-gui \
    && cd /usr/src/htmldoc/htmldoc \
    && make -j"$(nproc)" install \
    && cd /usr/src/htmldoc/fonts \
    && make -j"$(nproc)" install \
    && cd /usr/src/htmldoc/data \
    && make -j"$(nproc)" install \
    && apk add --no-cache --virtual .pdf-rundeps \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }') \
    && apk del --no-cache .build-deps \
    && rm -rf /usr/src /usr/local/share/doc /usr/local/share/man \
    && find /usr/local -name '*.a' -delete
