FROM rekgrpth/gost
RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
        g++ \
        gcc \
        git \
        gnutls-dev \
        jpeg-dev \
        libpng-dev \
        linux-headers \
        make \
        musl-dev \
        zlib-dev \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone --recursive https://github.com/RekGRpth/htmldoc.git \
    && cd /usr/src/htmldoc \
    && ./configure --without-gui \
    && cd /usr/src/htmldoc/htmldoc \
    && make -j"$(nproc)" install \
    && cd /usr/src/htmldoc/fonts \
    && make -j"$(nproc)" install \
    && cd /usr/src/htmldoc/data \
    && make -j"$(nproc)" install \
    && (strip /usr/local/bin/* /usr/local/lib/*.so || true) \
    && apk add --no-cache --virtual .pdf-rundeps \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }') \
    && apk del --no-cache .build-deps \
    && rm -rf /usr/src /usr/local/share/doc /usr/local/share/man \
    && find /usr/local -name '*.a' -delete
