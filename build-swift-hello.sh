# Configurable
source swift-define

set -e

# Build paths
SWIFT_HELLO_SRCDIR=$SRC_ROOT/swift-hello
SWIFT_HELLO_BUILDDIR=$SRC_ROOT/build/swift-hello
./build-swift-package.sh

echo "Copy swift-hello"
cp $SWIFT_HELLO_BUILDDIR/${SWIFTPM_CONFIGURATION}/swift-hello ${STAGING_DIR}/usr/bin/swift-hello
