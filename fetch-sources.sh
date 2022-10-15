#!/bin/bash
set -e
source swift-define

mkdir -p ./downloads
mkdir -p ./build

# Download Swift
DOWNLOAD_FILE=./downloads/swift-${SWIFT_VERSION}.tar.gz
SRCDIR=./downloads/swift-$SWIFT_VERSION
SRCURL=https://github.com/apple/swift/archive/refs/tags/$SWIFT_VERSION.tar.gz
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download Swift ${SWIFT_VERSION}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
rm -rf $SRCDIR
mkdir -p $SRCDIR
tar -xf $DOWNLOAD_FILE -C ./downloads

DOWNLOAD_FILE=./downloads/swift-stdlib-float16.patch
SRCURL=https://gist.githubusercontent.com/colemancda/ed295f963493726b1c01a6bc97945a3d/raw/8392d963c96ee5c910b816734afca4295a7e09c7/Float16.patch
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download ${DOWNLOAD_FILE}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
patch ./downloads/swift-$SWIFT_VERSION/stdlib/public/runtime/Float16Support.cpp $DOWNLOAD_FILE

# Download Dispatch
DOWNLOAD_FILE=./downloads/libdispatch-${SWIFT_VERSION}.tar.gz
SRCDIR=./downloads/swift-corelibs-libdispatch-$SWIFT_VERSION
SRCURL=https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/$SWIFT_VERSION.tar.gz
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download Dispatch ${SWIFT_VERSION}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
rm -rf $SRCDIR
mkdir -p $SRCDIR
tar -xf $DOWNLOAD_FILE -C ./downloads

# Download Foundation
DOWNLOAD_FILE=./downloads/foundation-${SWIFT_VERSION}.tar.gz
SRCDIR=./downloads/swift-corelibs-foundation-$SWIFT_VERSION
SRCURL=https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/$SWIFT_VERSION.tar.gz
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download Foundation ${SWIFT_VERSION}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
rm -rf $SRCDIR
mkdir -p $SRCDIR
tar -xf $DOWNLOAD_FILE -C ./downloads

# Download XCTest
DOWNLOAD_FILE=./downloads/xctest-${SWIFT_VERSION}.tar.gz
SRCDIR=./downloads/swift-corelibs-xctest-$SWIFT_VERSION
SRCURL=https://github.com/apple/swift-corelibs-xctest/archive/refs/tags/$SWIFT_VERSION.tar.gz
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download XCTest ${SWIFT_VERSION}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
rm -rf $SRCDIR
mkdir -p $SRCDIR
tar -xf $DOWNLOAD_FILE -C ./downloads

# Download LLVM
DOWNLOAD_FILE=./downloads/llvm-${SWIFT_VERSION}.tar.gz
SRCDIR=./downloads/llvm-project-$SWIFT_VERSION
SRCURL=https://github.com/apple/llvm-project/archive/refs/tags/$SWIFT_VERSION.tar.gz
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download LLVM ${SWIFT_VERSION}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
rm -rf $SRCDIR
mkdir -p $SRCDIR
tar -xf $DOWNLOAD_FILE -C ./downloads