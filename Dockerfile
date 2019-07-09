FROM rekgrpth/gost

RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual .build-deps \
        boost \
        boost-dev \
        cmake \
        fcgi-dev \
        g++ \
        git \
        glu-dev \
        graphicsmagick-dev \
        libharu-dev \
        make \
        mesa-dev \
        openssl-dev \
#        pango-dev \
#        postgresql-dev \
        qt5-qtbase-dev \
        qt5-qtsvg-dev \
        qt5-qtwebkit-dev \
        qt5-qtxmlpatterns-dev \
#        sqlite-dev \
        zlib-dev \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone https://github.com/RekGRpth/wkhtmltopdf.git \
    && git clone https://github.com/RekGRpth/wt.git \
    && cd /usr/src/wkhtmltopdf \
    && qmake-qt5 -makefile && make -j"$(nproc)" && make -j"$(nproc)" install INSTALL_ROOT=/usr/local \
    && cd /usr/src/wt \
    && cmake \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCONNECTOR_FCGI=OFF \
        -DCONNECTOR_HTTP=OFF \
        -DENABLE_FIREBIRD=OFF \
        -DENABLE_LIBWTDBO=OFF \
        -DENABLE_LIBWTTEST=OFF \
        -DENABLE_MSSQLSERVER=OFF \
        -DENABLE_MYSQL=OFF \
        -DENABLE_PANGO=OFF \
        -DENABLE_POSTGRES=OFF \
        -DENABLE_SQLITE=OFF \
        -DSHARED_LIBS=ON \
        . \
    && make -j"$(nproc)" && make -j"$(nproc)" install \
    && rm -rf /usr/src \
    && (strip /usr/local/bin/* /usr/local/lib/*.so || true) \
    && apk add --no-cache --virtual .pdf-rundeps \
        ttf-dejavu \
        $( scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        ) \
    && apk del --no-cache .build-deps \
