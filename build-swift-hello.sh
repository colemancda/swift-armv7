#!/bin/bash
set -e
source swift-define

# Build paths
export SWIFT_PACKAGE_SRCDIR=$SRC_ROOT/swift-hello
export SWIFT_PACKAGE_BUILDDIR=$SRC_ROOT/build/swift-hello
mkdir -p $SWIFT_PACKAGE_BUILDDIR
./build-swift-package.sh

echo "Copy swift-hello"
cp $SWIFT_PACKAGE_BUILDDIR/${SWIFTPM_CONFIGURATION}/swift-hello ${STAGING_DIR}/usr/bin/swift-hello
