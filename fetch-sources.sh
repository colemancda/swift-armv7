#!/bin/bash
set -e
source swift-define

mkdir -p ./downloads
mkdir -p ./build

# Fetch sources
cd ./downloads
if [[ -d "$SWIFT_SRCDIR" ]]; then
    echo "$SWIFT_SRCDIR exists"
else
    echo "Download Swift"
    git clone https://github.com/apple/swift.git
fi
./swift/utils/update-checkout --clone --tag $SWIFT_VERSION

# Patch Swift
echo "Patch Swift"
cd swift
# git apply $SRC_ROOT/patches/swift/001-Float16.patch
patch $SWIFT_SRCDIR/stdlib/public/runtime/Float16Support.cpp $SRC_ROOT/patches/swift/001-Float16.patch
git apply $SRC_ROOT/patches/swift/swift-include-swift-AST-Expr.h.patch
git apply $SRC_ROOT/patches/swift/swift-include-swift-Basic-BridgingUtils.h.patch
