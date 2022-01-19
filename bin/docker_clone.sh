#!/bin/sh -eux

mkdir -p "$HOME/src"
cd "$HOME/src"
git clone -b main https://github.com/RekGRpth/libinjection.git
git clone -b master https://github.com/RekGRpth/handlebars.c.git
git clone -b master https://github.com/RekGRpth/htmldoc.git
git clone -b master https://github.com/RekGRpth/libgraphqlparser.git
git clone -b master https://github.com/RekGRpth/libjwt.git
git clone -b master https://github.com/RekGRpth/mustach.git
