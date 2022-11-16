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
if [[ -d "$XCTOOLCHAIN" ]]; then
    echo "Toolchain extracted"
else
    echo "Extract toolchain"
    rm -rf /tmp/cross-toolchain
    rm -rf $XCTOOLCHAIN
    mkdir -p $XCTOOLCHAIN
    ./generate-xcode-toolchain-impl.sh /tmp/ ./downloads/${SWIFT_VERSION}-osx.pkg $INSTALL_TAR
    cp -rf /tmp/cross-toolchain/swift-armv7.xctoolchain/* $XCTOOLCHAIN/
fi

# Extract Swift runtime
if [[ -d "$SWIFT_INSTALL_PREFIX" ]]; then
    echo "Swift runtime exists"
else
    echo "Extract Swift runtime"
    rm -rf $SWIFT_INSTALL_PREFIX
    mkdir -p $SWIFT_INSTALL_PREFIX
    cd $SWIFT_INSTALL_PREFIX
    tar -xf $INSTALL_TAR
    cd $SRC_ROOT
fi

# Build SDK
echo "Build SDK $XCTOOLCHAIN_SDK"
cp -rf $STAGING_DIR/lib $XCTOOLCHAIN_SDK/
cp -rf $STAGING_DIR/usr/lib $XCTOOLCHAIN_SDK/usr/
cp -rf $STAGING_DIR/usr/include $XCTOOLCHAIN_SDK/usr/
cp -rf $SWIFT_INSTALL_PREFIX/usr/lib $XCTOOLCHAIN_SDK/usr/
cp -rf /tmp/cross-toolchain/swift-armv7.xctoolchain/usr/lib/swift $XCTOOLCHAIN_SDK/usr/lib/

# Generate destination.json
export STAGING_DIR=$XCTOOLCHAIN_SDK
./generate-swiftpm-toolchain.sh
