#!/bin/sh -eux

ln -fs libldap.a /usr/lib/libldap_r.a
ln -fs libldap.so /usr/lib/libldap_r.so
cd "$HOME/src/handlebars.c" && ./configure --disable-refcounting --disable-static && make -j"$(nproc)" install
cd "$HOME/src/htmldoc" && ./configure --without-gui
cd "$HOME/src/htmldoc/data" && make -j"$(nproc)" install
cd "$HOME/src/htmldoc/fonts" && make -j"$(nproc)" install
cd "$HOME/src/htmldoc/htmldoc" && make -j"$(nproc)" install
cd "$HOME/src/libgraphqlparser" && cmake . && make -j"$(nproc)" install
cd "$HOME/src/libinjection/src" && make -j"$(nproc)" install
cd "$HOME/src/libjwt" && autoreconf -vif && ./configure && make -j"$(nproc)" install
cd "$HOME/src/mustach" && make -j"$(nproc)" libs=single install
