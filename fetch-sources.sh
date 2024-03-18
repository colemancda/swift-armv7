#!/bin/bash
set -e
source swift-define

mkdir -p $WORKSPACE_DIR

# Fetch sources
cd $WORKSPACE_DIR
if [[ -d "$SWIFT_SRCDIR" ]]; then
    echo "$SWIFT_SRCDIR exists"
else
    echo "Checkout Swift"
    git clone https://github.com/apple/swift.git
    ./swift/utils/update-checkout --clone --tag $SWIFT_VERSION
    # Patch Swift
    echo "Patch Swift"
    cd ./swift
    git apply $SRC_ROOT/patches/0001-Swift-stdlib-float16.patch
    git apply $SRC_ROOT/patches/0002-Fix-swift-build-support-product-method-typo.patch
fi

# NOTE: If this folder is not removed, the Swift build scripts attempt to build the
# CMake bootstrap, which breaks the build since it appears to be looking for libraries
# and compilers in places it shouldn't be for the cross compilation build.
# Setting bootstrapping=off doesn't seem to make a difference here.
cd $WORKSPACE_DIR
if [[ -d "cmake" ]]; then
    echo "Removing cmake directory to skip bootstrap build..."
    rm -rf cmake
fi
