FROM rekgrpth/gost
RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
        cjson-dev \
        clang \
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
        linux-headers \
        make \
        musl-dev \
        zlib-dev \
    ; \
    mkdir -p /usr/src; \
    cd /usr/src; \
    git clone --recursive https://github.com/RekGRpth/htmldoc.git; \
    git clone --recursive https://github.com/RekGRpth/mustach.git; \
    cd /usr/src/htmldoc; \
    ./configure --without-gui; \
    cd /usr/src/htmldoc/htmldoc; \
    make -j"$(nproc)" install; \
    cd /usr/src/htmldoc/fonts; \
    make -j"$(nproc)" install; \
    cd /usr/src/htmldoc/data; \
    make -j"$(nproc)" install; \
    cd /usr/src/mustach; \
    make -j"$(nproc)" libs=single install; \
    cd /; \
    (strip /usr/local/bin/* /usr/local/lib/*.so || true); \
    apk add --no-cache --virtual .pdf-rundeps \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
    ; \
    apk del --no-cache .build-deps; \
    rm -rf /usr/src /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr/local -name '*.a' -delete; \
    echo done
