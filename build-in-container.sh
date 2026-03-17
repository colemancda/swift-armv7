#!/bin/bash

set -e

# Build container
source ./swift-builder/swift-builder-common
./swift-builder/build-container.sh

BUILD_SCRIPT=$1
if [ -z $BUILD_SCRIPT ]; then
    BUILD_SCRIPT=./build.sh
fi

# Build Swift
echo "Building Swift ${SWIFT_TAG} using ${DOCKER_TAG}..."
docker run \
    --rm -ti \
    --user ${USER}:${USER} \
    --volume $(pwd):/src \
    --workdir /src \
    -e SWIFT_VERSION=${SWIFT_TAG} \
    -e STAGING_DIR=${STAGING_DIR} \
    -e SWIFT_BUILD_CONFIGURATION=${SWIFT_BUILD_CONFIGURATION} \
    -e SWIFTPM_CONFIGURATION=${SWIFTPM_CONFIGURATION} \
    -e INSTALL_TAR=${INSTALL_TAG} \
    -e SKIP_FETCH_SOURCES=${SKIP_FETCH_SOURCES} \
    -e SWIFT_TARGET_ARCH=${SWIFT_TARGET_ARCH} \
    -e STATIC_SWIFT_STDLIB=${STATIC_SWIFT_STDLIB} \
    ${DOCKER_TAG} ${BUILD_SCRIPT}
