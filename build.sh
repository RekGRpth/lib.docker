#!/bin/sh -eux

DOCKER_BUILDKIT=1 docker build --progress=plain --tag rekgrpth/pdf . 2>&1 | tee build.log
