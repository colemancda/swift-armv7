#!/bin/bash

if [ -z $SWIFT_VERSION ]; then
    echo "You must provide a Swift version (such as 6.0.3) to this script!"
    exit -1
fi

export DOCKER_TAG=${DOCKER_TAG:=xtremekforever/swift-builder:${SWIFT_VERSION}-gh-runner}
export BUILD_USER=runner
export BUILD_USER_ID=1001

SCRIPT_DIR=$(dirname "$0")
source ${SCRIPT_DIR}/swift-builder-common

./build-container.sh

if [ ! -z $PUSH ]; then
    echo "Pushing ${DOCKER_TAG} now..."
    docker push $DOCKER_TAG
fi
