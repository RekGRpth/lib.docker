#!/bin/sh -x

docker build --tag rekgrpth/pdf . | tee build.log
