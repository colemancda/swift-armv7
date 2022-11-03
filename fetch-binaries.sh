
#!/bin/bash
set -e
source swift-define

mkdir -p ./build
mkdir -p ./downloads

# Download Debian 11 sysroot
DOWNLOAD_FILE=./downloads/bullseye-armv7.tar
SRCURL=https://github.com/colemancda/swift-armv7/releases/download/0.4.0/bullseye-armv7.tar
if [[ -d "$STAGING_DIR/usr/lib" ]]; then
    echo "Use existing Sysroot"
else
    echo "Download bullseye-armv7.tar"
    touch $DOWNLOAD_FILE
    wget -q $SRCURL -O $DOWNLOAD_FILE
    mkdir -p $STAGING_DIR
    tar -xf $DOWNLOAD_FILE -C ./downloads
    rm -rf $DOWNLOAD_FILE
    cp -rf ./downloads/bullseye-armv7/* $STAGING_DIR/
    rm -rf ./downloads/bullseye-armv7
fi

if [[ $OSTYPE == 'darwin'* ]]; then

    # Download Swift Xcode toolchain
    DOWNLOAD_FILE=$PREBUILT_XCTOOLCHAIN
    SRCURL="https://download.swift.org/swift-5.7.1-release/xcode/${SWIFT_VERSION}/${SWIFT_VERSION}-osx.pkg"
    if test -f "$DOWNLOAD_FILE"; then
        echo "${SWIFT_VERSION}-osx.pkg exists"
    else
        echo "Download ${SWIFT_VERSION}-osx.pkg"
        wget -q $SRCURL -O $DOWNLOAD_FILE
    fi

    # Download prebuilt Swift for Armv7
    DOWNLOAD_FILE=$INSTALL_TAR
    SRCURL=https://github.com/colemancda/swift-armv7/releases/download/0.4.0/swift-armv7.tar.gz
    if test -f "$DOWNLOAD_FILE"; then
        echo "swift-armv7.tar.gz exists"
    else
        echo "Download swift-armv7.tar.gz"
        wget -q $SRCURL -O $DOWNLOAD_FILE
    fi
fi
