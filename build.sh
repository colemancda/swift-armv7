#!/bin/bash
set -e
source swift-define

# Fetch and patch sources
./fetch-sources.sh
# Build runtime
if [[ -d "$LLVM_INSTALL_PREFIX" ]]; then
    echo "Using built LLVM"
else
    ./build-llvm.sh
fi
./build-swift-stdlib.sh
./build-dispatch.sh
./build-foundation.sh
./build-xctest.sh
# Cross compile test package
./generate-swiftpm-toolchain.sh
./build-swift-hello.sh
# Archive
./build-tar.sh
# Generate Xcode toolchain
if [[ $OSTYPE == 'darwin'* ]]; then
  echo "Generate Xcode toolchain for cross compiling"
    curl -o ./downloads/${SWIFT_VERSION}-osx.pkg https://download.swift.org/swift-5.7-release/xcode/${SWIFT_VERSION}/${SWIFT_VERSION}-osx.pkg
    ./generate-xcode-toolchain.sh /tmp/ ./downloads/${SWIFT_VERSION}-osx.pkg ./build/swift-armv7.tar.gz
fi
