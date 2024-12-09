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

# Build LLVM
./build-llvm.sh

# Build Swift
./build-swift-stdlib.sh
./build-dispatch.sh
./build-foundation.sh
./build-xctest.sh
if [[ $SWIFT_VERSION == *"6.0"* ]]; then
    ./build-swift-testing.sh
fi

# Archive
./build-tar.sh

# Cross compile test package
./generate-swiftpm-toolchain.sh
./build-swift-hello.sh
