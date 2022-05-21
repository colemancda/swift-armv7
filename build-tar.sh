# Configurable
source .config
source swift-define

set -e

# Build paths
SWIFT_INSTALL_PREFIX=$SRC_ROOT/build/swift-armv7-install/usr
LIBDISPATCH_INSTALL_PREFIX=$SRC_ROOT/build/libdispatch-armv7-install/usr
FOUNDATION_INSTALL_PREFIX=$SRC_ROOT/build/foundation-armv7-install/usr
INSTALL_PREFIX=$SRC_ROOT/build/swift-install/usr
INSTALL_TAR=$SRC_ROOT/build/swift-armv7.tar.gz

# Combine build output
rm -rf $INSTALL_TAR
rm -rf $INSTALL_PREFIX
mkdir -p $INSTALL_PREFIX
cp -rf $SWIFT_INSTALL_PREFIX/* $INSTALL_PREFIX/
cp -rf $LIBDISPATCH_INSTALL_PREFIX/* $INSTALL_PREFIX/
cp -rf $FOUNDATION_INSTALL_PREFIX/* $INSTALL_PREFIX/

# compress
cd $SRC_ROOT/build/swift-install
tar -czvf $INSTALL_TAR .
