FROM ghcr.io/rekgrpth/gost.docker
RUN set -eux; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        bison \
        check-dev \
        clang \
        cmake \
        file \
        flex \
        fltk-dev \
        g++ \
        gcc \
        git \
        gnutls-dev \
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
    ; \
    mkdir -p "${HOME}/src"; \
    cd "${HOME}/src"; \
    git clone -b master https://github.com/RekGRpth/handlebars.c.git; \
    git clone -b master https://github.com/RekGRpth/htmldoc.git; \
    git clone -b master https://github.com/RekGRpth/libgraphqlparser.git; \
    git clone -b master https://github.com/RekGRpth/mustach.git; \
    cd "${HOME}/src/handlebars.c"; \
    ./configure --disable-refcounting --disable-static; \
    make -j"$(nproc)" install; \
    cd "${HOME}/src/htmldoc"; \
    ./configure --without-gui; \
    cd "${HOME}/src/htmldoc/htmldoc"; \
    make -j"$(nproc)" install; \
    cd "${HOME}/src/htmldoc/fonts"; \
    make -j"$(nproc)" install; \
    cd "${HOME}/src/htmldoc/data"; \
    make -j"$(nproc)" install; \
    cd "${HOME}/src/libgraphqlparser"; \
    cmake .; \
    make -j"$(nproc)" install; \
    cd "${HOME}/src/mustach"; \
    make -j"$(nproc)" libs=single install; \
    cd /; \
    apk add --no-cache --virtual .lib-rundeps \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build-deps; \
    find /usr -type f -name "*.a" -delete; \
    find /usr -type f -name "*.la" -delete; \
    rm -rf "${HOME}" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    echo done
