#!/bin/bash
set -e
source swift-define

if [[ "$DOWNLOAD_SWIFT_RUNTIME" == "1" ]]; then

    # Download prebuilt Swift for Armv7
    DOWNLOAD_FILE=$INSTALL_TAR
    SRCURL=https://github.com/colemancda/swift-armv7/releases/download/0.5.1/swift-armv7.tar.gz
    if test -f "$DOWNLOAD_FILE"; then
        echo "swift-armv7.tar.gz exists"
    else
        echo "Download swift-armv7.tar.gz"
        wget -q $SRCURL -O $DOWNLOAD_FILE
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
fi

# Download Debian 11 sysroot
DOWNLOAD_FILE=$SRC_ROOT/downloads/bullseye-armv7.tar
SRCURL=https://github.com/colemancda/swift-armv7/releases/download/0.4.0/bullseye-armv7.tar
if [[ -d "$STAGING_DIR/usr/lib" ]]; then
    echo "Use existing Sysroot"
else
    echo "Download bullseye-armv7.tar"
    touch $DOWNLOAD_FILE
    wget -q $SRCURL -O $DOWNLOAD_FILE
    mkdir -p $STAGING_DIR
    tar -xf $DOWNLOAD_FILE -C $SRC_ROOT/downloads
    rm -rf $DOWNLOAD_FILE
    cp -rf $SRC_ROOT/downloads/bullseye-armv7/* $STAGING_DIR/
    rm -rf $SRC_ROOT/downloads/bullseye-armv7
fi

if [[ $OSTYPE == 'darwin'* ]]; then

    # Download Swift Xcode toolchain
    DOWNLOAD_FILE=$PREBUILT_XCTOOLCHAIN
    SRCURL="https://download.swift.org/swift-5.10-release/xcode/${SWIFT_VERSION}/${SWIFT_VERSION}-osx.pkg"
    if test -f "$DOWNLOAD_FILE"; then
        echo "${SWIFT_VERSION}-osx.pkg exists"
    else
        echo "Download ${SWIFT_VERSION}-osx.pkg"
        wget -q $SRCURL -O $DOWNLOAD_FILE
    fi
fi
