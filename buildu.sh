#!/bin/sh -eux

docker build --progress=plain --tag "ghcr.io/rekgrpth/lib.docker:${INPUTS_BRANCH:-ubuntu}" $(env | grep -E '^DOCKER_' | grep -v ' ' | sort -u | sed 's@^@--build-arg @g' | paste -s -d ' ') --file "${INPUTS_DOCKERFILE:-Dockerfile.ubuntu}" . 2>&1 | tee build.log