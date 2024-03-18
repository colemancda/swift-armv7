#!/bin/bash
set -e
source swift-define

if [[ $OSTYPE == 'darwin'* ]]; then
    echo "Install macOS build dependencies"
    ./setup-mac.sh
fi

# Fetch and patch sources
./fetch-sources.sh
./fetch-binaries.sh

# Generate Xcode toolchain
if [[ $OSTYPE == 'darwin'* && ! -d "$XCTOOLCHAIN" ]]; then
    mkdir -p $XCTOOLCHAIN
    ./generate-xcode-toolchain-impl.sh /tmp/ ./downloads/${SWIFT_VERSION}-osx.pkg $INSTALL_TAR
    cp -rf /tmp/cross-toolchain/swift-armv7.xctoolchain/* $XCTOOLCHAIN/
fi

# Cleanup previous build
rm -rf $STAGING_DIR/usr/lib/swift*
rm -rf $SWIFT_INSTALL_PREFIX

# Create symbolic link
mkdir -p ${SWIFT_INSTALL_PREFIX}/usr/lib/swift/linux/${SWIFT_TARGET_ARCH}
ln -s ${SWIFT_INSTALL_PREFIX}/usr/lib/swift/linux/${SWIFT_TARGET_ARCH} ${SWIFT_INSTALL_PREFIX}/usr/lib/swift/linux/"$(uname -m)"

# Generate SwiftPM destination file
./generate-swiftpm-toolchain.sh
cp -rf $SWIFTPM_DESTINATION_FILE $SWIFT_INSTALL_PREFIX/usr/swiftpm.json

# Build Swift
./build-llvm.sh
./build-swift-stdlib.sh
./build-swift-libs.sh

# Archive
./build-tar.sh
