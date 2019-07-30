FROM rekgrpth/gost
RUN set -ex \
    && apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        brotli-dev \
        dev86 \
        file \
#        freeglut-dev \
        freetype-dev \
        gcc \
        gettext-dev \
        git \
        harfbuzz-dev \
        jbig2dec-dev \
        jpeg-dev \
        libidn-dev \
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
    && git clone --recursive https://github.com/RekGRpth/mupdf.git \
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
    && cd /usr/src/mupdf \
    && make -j"$(nproc)" USE_SYSTEM_LIBS=yes HAVE_X11=no HAVE_GLUT=no prefix=/usr/local CURL_LIBS='-lcurl -lpthread' build=release install \
    && apk add --no-cache --virtual .mupdf-rundeps \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }') \
    && apk del --no-cache .build-deps \
    && rm -rf /usr/src /usr/local/share/doc /usr/local/share/man \
    && find /usr/local -name '*.a' -delete
