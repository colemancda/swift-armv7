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