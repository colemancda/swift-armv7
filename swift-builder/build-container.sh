#!/bin/bash

set -e

SCRIPT_DIR=$(dirname "$0")
source ${SCRIPT_DIR}/swift-builder-common

echo "Building container for Swift $SWIFT_VERSION, branch $SWIFT_BRANCH, tag $SWIFT_TAG..."
docker build \
    --build-arg SWIFT_VERSION=${SWIFT_TAG} \
    --build-arg SWIFT_BRANCH=${SWIFT_BRANCH} \
    --build-arg USER=${BUILD_USER} \
    --build-arg UID=${BUILD_USER_ID} \
    -t ${DOCKER_TAG} \
    ${SCRIPT_DIR}
