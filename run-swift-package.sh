#!/bin/bash

set -e
source swift-define

# NOTE: Run this directly on the host instead of through the builder container for best results.
# I've seen that we get unexpected instruction errors inside of Docker when running qemu-arm.

EXECUTABLE=$1
EXECUTABLE_ARGS=${@:2}

SWIFT_PACKAGE_OUTPUT_DIR=$SWIFT_PACKAGE_BUILDDIR/${SWIFTPM_CONFIGURATION}
QEMU_ARGS="-L $STAGING_DIR -E LD_LIBRARY_PATH=$STAGING_DIR/usr/lib/swift/linux"

echo "Running $EXECUTABLE binary in qemu..."
qemu-arm $QEMU_ARGS $SWIFT_PACKAGE_OUTPUT_DIR/$EXECUTABLE $EXECUTABLE_ARGS
echo "Exit code for $EXECUTABLE: $?"
