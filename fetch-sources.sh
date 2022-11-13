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
    echo "Checkout Swift"
    git clone https://github.com/apple/swift.git
    ./swift/utils/update-checkout --clone --tag $SWIFT_VERSION
    # Patch Swift
    echo "Patch Swift"
    cd ./swift
    # git apply $SRC_ROOT/patches/swift/001-Float16.patch
    patch $SWIFT_SRCDIR/stdlib/public/runtime/Float16Support.cpp $SRC_ROOT/patches/swift/patches/swift/001-swift-float16.patch
    git apply $SRC_ROOT/patches/swift/002-swift-include-swift-AST-Expr.h.patch
    git apply $SRC_ROOT/patches/swift/003-swift-include-swift-Basic-BridgingUtils.h.patch
    git apply $SRC_ROOT/patches/swift/004-swift-targets.patch
    cd ../swiftpm
    git apply $SRC_ROOT/patches/swiftpm/patches/swiftpm/001-swiftpm-bootstrap.patch
    cd ../sourcekit-lsp
    git apply $SRC_ROOT/patches/sourcekit-lsp/001-sourcekit-lsp-build-script-helper.patch
fi
