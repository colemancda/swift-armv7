#!/bin/bash
set -e
# Fetch and patch sources
./fetch-sources.sh
# Build runtime
./build-swift-stdlib.sh
./build-dispatch.sh
./build-foundation.sh
# Cross compile test package
./generate-swiftpm-toolchain.sh
./build-swift-hello.sh
# Archive
./build-tar.sh