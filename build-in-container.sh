#!/bin/bash

set -e

# Build container
source ./swift-builder/swift-builder-common
./swift-builder/build-container.sh

# Build Swift
echo "Building Swift ${SWIFT_TAG} using ${DOCKER_TAG}..."
docker run \
    --rm -ti \
    --user ${USER}:${USER} \
    --volume $(pwd):/src \
    --workdir /src \
    -e SWIFT_VERSION=${SWIFT_TAG} \
    -e STAGING_DIR=${STAGING_DIR} \
    -e INSTALL_TAR=${INSTALL_TAG} \
    ${DOCKER_TAG} \
    ./build.sh
