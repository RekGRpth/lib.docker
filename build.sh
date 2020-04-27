#!/bin/sh -ex

docker build --tag rekgrpth/pdf . | tee build.log
