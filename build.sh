#!/bin/bash
set -e
source swift-define

if [[ $OSTYPE == 'darwin'* ]]; then
    echo "Install macOS build dependencies"
    ./setup-mac.sh
fi

# Fetch and patch sources
if [ -z $SKIP_FETCH_SOURCES ]; then
    ./fetch-sources.sh
fi
./fetch-binaries.sh

# Generate Xcode toolchain
if [[ $OSTYPE == 'darwin'* && ! -d "$XCTOOLCHAIN" ]]; then
    mkdir -p $XCTOOLCHAIN
    ./generate-xcode-toolchain-impl.sh /tmp/ ./downloads/${SWIFT_VERSION}-osx.pkg $INSTALL_TAR
    cp -rf /tmp/cross-toolchain/swift-armv7.xctoolchain/* $XCTOOLCHAIN/
fi

# Cleanup previous build
rm -rf $STAGING_DIR/usr/lib/swift*

# Configure LLVM
./configure-llvm.sh

# This is required for cross-compiling dispatch, foundation, etc
./create-cmake-toolchain.sh

# Build Swift
./build-swift-stdlib.sh

# Build corelibs shared
./build-dispatch.sh
./build-foundation.sh
./build-xctest.sh

# Build corelibs static
STATIC_BUILD=1 ./build-dispatch.sh
STATIC_BUILD=1 ./build-foundation.sh
# We don't do XCTest and Testing because the official Swift distributions

# Enable Swift Testing for 6.0 and later
if [[ $SWIFT_VERSION == *"swift-6."* ]] || [[ $SWIFT_VERSION == *"swift-DEVELOPMENT"* ]]; then
    ./build-swift-testing.sh
fi

./deploy-to-sysroot.sh

# Archive
./build-tar.sh

# Cross compile test package
./generate-swiftpm-toolchain.sh
./build-swift-hello.sh

# Cross compile test package with --static-swift-stdlib
export STATIC_SWIFT_STDLIB=1 
./generate-swiftpm-toolchain.sh
./build-swift-hello.sh
