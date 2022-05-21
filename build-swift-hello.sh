# Configurable
source swift-define

set -e

# Build paths
SWIFT_HELLO_SRCDIR=$SRC_ROOT/swift-hello
SWIFT_HELLO_BUILDDIR=$SRC_ROOT/build/swift-hello

echo "Cross compile swift-hello"
rm -rf $SWIFT_HELLO_BUILDDIR
mkdir -p $SWIFT_HELLO_BUILDDIR
cd $SWIFT_HELLO_SRCDIR
$SWIFT_NATIVE_PATH/swift build -c ${SWIFTPM_CONFIGURATION} --build-path ${SWIFT_HELLO_BUILDDIR} --destination ${SWIFTPM_DESTINATION_FILE}

echo "Copy swift-hello"
sudo cp $SWIFT_HELLO_BUILDDIR/${SWIFTPM_CONFIGURATION}/swift-hello ${STAGING_DIR}/usr/local/bin