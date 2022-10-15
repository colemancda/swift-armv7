#!/bin/bash
set -e
# Fetch and patch sources
./fetch-sources.sh
# Build runtime
./build-llvm.sh
./build-swift-stdlib.sh
./build-dispatch.sh
./build-foundation.sh
./build-xctest.sh
# Cross compile test package
./generate-swiftpm-toolchain.sh
./build-swift-hello.sh
# Archive
./build-tar.sh