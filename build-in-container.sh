#!/bin/bash

set -e

# Build container
source ./swift-builder/swift-builder-common
./swift-builder/build-container.sh

# Build Swift
echo "Building Swift ${SWIFT_TAG} using ${DOCKER_TAG}..."
docker run \
    --rm -ti \
    --user ${BUILD_USER}:${BUILD_USER} \
    --volume $(pwd):/src \
    --workdir /src \
    -e SWIFT_VERSION=${SWIFT_TAG} \
    ${DOCKER_REPO}swift-builder:${SWIFT_VERSION} \
    ./build.sh
