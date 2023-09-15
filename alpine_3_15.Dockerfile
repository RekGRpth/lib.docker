FROM ghcr.io/rekgrpth/gost.docker:alpine_3_15
RUN set -eux; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    apk add --no-cache --virtual .build \
        autoconf \
        automake \
        bison \
        check-dev \
        cjson-dev \
        clang \
        cups-dev \
#        cmake \
        file \
        flex \
        fltk-dev \
        g++ \
        gcc \
        git \
#        gnutls-dev \
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
#        openssl3-dev \
        pcre2-dev \
        pcre-dev \
#        python2 \
        subunit-dev \
#        talloc-dev \
        yaml-dev \
        zlib-dev \
    ; \
    mkdir -p "$HOME/src"; \
    cd "$HOME/src"; \
#    git clone -b main https://github.com/RekGRpth/libinjection.git; \
#    git clone -b master https://github.com/RekGRpth/handlebars.c.git; \
    git clone -b master https://github.com/RekGRpth/htmldoc.git; \
#    git clone -b master https://github.com/RekGRpth/libgraphqlparser.git; \
#    git clone -b master https://github.com/RekGRpth/libjwt.git; \
    git clone -b master https://github.com/RekGRpth/mustach.git; \
    ln -fs libldap.a /usr/lib/libldap_r.a; \
    ln -fs libldap.so /usr/lib/libldap_r.so; \
#    cd "$HOME/src/handlebars.c" && ./configure --disable-refcounting --disable-static && make -j"$(nproc)" install; \
    cd "$HOME/src/htmldoc" && ./configure --without-gui && cd "$HOME/src/htmldoc/data" && make -j"$(nproc)" install && cd "$HOME/src/htmldoc/fonts" && make -j"$(nproc)" install && cd "$HOME/src/htmldoc/htmldoc" && make -j"$(nproc)" install; \
#    cd "$HOME/src/libgraphqlparser" && cmake . && make -j"$(nproc)" install; \
#    cd "$HOME/src/libinjection/src" && make -j"$(nproc)" install; \
#    cd "$HOME/src/libjwt" && autoreconf -vif && ./configure && make -j"$(nproc)" install; \
    cd "$HOME/src/mustach" && make -j"$(nproc)" libs=single install; \
    apk add --no-cache --virtual .lib \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | grep -v "^$" | grep -v -e libcrypto | sort -u | while read -r lib; do test -z "$(find /usr/local/lib -name "$lib")" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    echo done
