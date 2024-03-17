#!/bin/bash
set -e
source swift-define

# Build paths
export SWIFT_PACKAGE_SRCDIR=$SRC_ROOT/swift-hello
export SWIFT_PACKAGE_BUILDDIR=$WORKSPACE_DIR/build/swift-hello
mkdir -p $SWIFT_PACKAGE_BUILDDIR
./build-swift-package.sh
