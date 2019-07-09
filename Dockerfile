FROM rekgrpth/gost

RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual .build-deps \
        qt5-qtbase-dev \
        qt5-qtsvg-dev \
        qt5-qtwebkit-dev \
        qt5-qtxmlpatterns-dev \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone https://github.com/RekGRpth/wkhtmltopdf.git \
    && cd /usr/src/wkhtmltopdf \
    && qmake-qt5 -makefile && make -j"$(nproc)" && make -j"$(nproc)" install INSTALL_ROOT=/usr/local \
    && (strip /usr/local/bin/* /usr/local/lib/*.so || true) \
    && apk add --no-cache --virtual .gost-rundeps \
        $( scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        ) \
    && apk del --no-cache .build-deps \
