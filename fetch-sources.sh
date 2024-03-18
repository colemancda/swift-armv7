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
