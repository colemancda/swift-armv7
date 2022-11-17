#!/bin/bash
set -e
source swift-define

if [[ $OSTYPE == 'darwin'* ]]; then
    echo "Install macOS build dependencies"
    ./setup-mac.sh
fi

# Download Swift runtime
DOWNLOAD_SWIFT_RUNTIME=1 ./fetch-binaries.sh

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

# Generate destination.json
./generate-swiftpm-toolchain.sh
