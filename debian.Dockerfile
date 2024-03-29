FROM ghcr.io/rekgrpth/gost.docker:debian
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    export savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get full-upgrade -y --no-install-recommends; \
    apt-get install -y --no-install-recommends \
        apt-utils \
        autoconf \
        automake \
        bison \
        check \
        clang \
#        cmake \
        file \
        flex \
        g++ \
        gcc \
        git \
#        gnutls-dev \
        libc-dev \
        libcjson-dev \
        libcups2-dev \
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
#        libtalloc-dev \
        libtool \
        libyaml-dev \
        make \
        pkg-config \
#        python2 \
#        python3 \
        zlib1g-dev \
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
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    find /usr/local -type f -executable -exec ldd '{}' ';' | grep -v 'not found' | awk '/=>/ { print $(NF-1) }' | sort -u | xargs -r dpkg-query --search | cut -d: -f1 | sort -u | xargs -r apt-mark manual; \
    find /usr/local -type f -executable -exec ldd '{}' ';' | grep -v 'not found' | awk '/=>/ { print $(NF-1) }' | sort -u | xargs -r -i echo "/usr{}" | xargs -r dpkg-query --search | cut -d: -f1 | sort -u  | xargs -r apt-mark manual; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/* /var/cache/ldconfig/aux-cache /var/cache/ldconfig; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    echo done
