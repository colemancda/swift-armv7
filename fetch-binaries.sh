
#!/bin/bash
set -e
source swift-define

mkdir -p ./downloads

if [[ $OSTYPE == 'darwin'* ]]; then

    # Download Swift Xcode toolchain
    DOWNLOAD_FILE=$PREBUILT_XCTOOLCHAIN
    SRCURL="https://download.swift.org/swift-5.7-release/xcode/${SWIFT_VERSION}/${SWIFT_VERSION}-osx.pkg"
    if test -f "$DOWNLOAD_FILE"; then
        echo "${SWIFT_VERSION}-osx.pkg exists"
    else
        echo "Download ${SWIFT_VERSION}-osx.pkg"
        wget $SRCURL -O $DOWNLOAD_FILE
    fi

    # Download prebuilt Swift for Armv7
    DOWNLOAD_FILE=./downloads/swift-armv7.tar.gz
    SRCURL=https://github.com/colemancda/swift-armv7/releases/download/0.4.0/swift-armv7.tar.gz
    if test -f "$DOWNLOAD_FILE"; then
        echo "swift-armv7.tar.gz exists"
    else
        echo "Download swift-armv7.tar.gz"
        wget $SRCURL -O $DOWNLOAD_FILE
    fi
fi

# Download prebuilt LLVM
if [[ ! -d "$LLVM_INSTALL_PREFIX" ]]; then
    mkdir -p $LLVM_INSTALL_PREFIX
    cd $LLVM_INSTALL_PREFIX
    echo "Download prebuilt LLVM"
    wget https://github.com/colemancda/swift-armv7/releases/download/0.4.0/llvm-swift.zip
    unzip llvm-swift.zip
    rm -rf llvm-swift.zip
fi

# Download Debian 11 sysroot
DOWNLOAD_FILE=./downloads/bullseye-armv7.tar
SRCURL=https://github.com/colemancda/swift-armv7/releases/download/0.4.0/bullseye-armv7.tar
if [[ -d "$STAGING_DIR/lib" ]]; then
    echo "Use existing Sysroot"
else
    echo "Download bullseye-armv7.tar"
    wget $SRCURL -O $DOWNLOAD_FILE
    mkdir -p $STAGING_DIR
    tar -xf $DOWNLOAD_FILE -C ./downloads
    rm -rf $DOWNLOAD_FILE
    cp -rf ./downloads/bullseye-armv7/* $STAGING_DIR/
    rm -rf ./downloads/bullseye-armv7
fi
