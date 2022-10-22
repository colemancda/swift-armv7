#!/bin/bash
set -e
source swift-define

if [[ $OSTYPE == 'darwin'* ]]; then
    echo "Install macOS build dependencies"
    ./setup-mac.sh
fi

# Download Swift runtime
./fetch-binaries.sh

# Extract toolchain
rm -rf /tmp/cross-toolchain
rm -rf $XCTOOLCHAIN
mkdir -p $XCTOOLCHAIN
./generate-xcode-toolchain-impl.sh /tmp/ ./downloads/${SWIFT_VERSION}-osx.pkg $INSTALL_TAR
cp -rf /tmp/cross-toolchain/swift-armv7.xctoolchain/* $XCTOOLCHAIN/

# Build SDK
SDK=/tmp/cross-toolchain/debian-bullseye.sdk
cp -rf $STAGING_DIR/lib $SDK/
cp -rf $STAGING_DIR/usr/lib $SDK/usr/
cp -rf $STAGING_DIR/usr/include $SDK/usr/
cp -rf /tmp/cross-toolchain/swift-armv7.xctoolchain/usr/lib/swift $SDK/usr/lib/

# Generate destination.json
export STAGING_DIR=$SDK
./generate-swiftpm-toolchain.sh
