#!/bin/bash
set -e
source swift-define

mkdir -p ./downloads
mkdir -p ./build

# Download Swift
DOWNLOAD_FILE=./downloads/swift-${SWIFT_VERSION}.tar.gz
SRCDIR=$SWIFT_SRCDIR
SRCURL=https://github.com/apple/swift/archive/refs/tags/$SWIFT_VERSION.tar.gz
if [[ -d "$SRCDIR" ]]; then
    echo "$SRCDIR exists"
else
    echo "Download Swift"
    wget -q $SRCURL -O $DOWNLOAD_FILE
    rm -rf $SRCDIR
    mkdir -p $SRCDIR
    tar -xf $DOWNLOAD_FILE -C ./downloads
    mv ./downloads/swift-$SWIFT_VERSION/* $SRCDIR
    rm -rf ./downloads/swift-$SWIFT_VERSION

    # Patch Swift
    DOWNLOAD_FILE=./downloads/swift-stdlib-float16.patch
    SRCURL=https://gist.githubusercontent.com/colemancda/ed295f963493726b1c01a6bc97945a3d/raw/8392d963c96ee5c910b816734afca4295a7e09c7/Float16.patch
    if test -f "$DOWNLOAD_FILE"; then
        echo "$DOWNLOAD_FILE exists"
    else
        echo "Download ${DOWNLOAD_FILE}"
        wget -q $SRCURL -O $DOWNLOAD_FILE
    fi
    patch $SWIFT_SRCDIR/stdlib/public/runtime/Float16Support.cpp $DOWNLOAD_FILE
fi

# Download Dispatch
DOWNLOAD_FILE=./downloads/libdispatch-${SWIFT_VERSION}.tar.gz
SRCDIR=$LIBDISPATCH_SRCDIR
SRCURL=https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/$SWIFT_VERSION.tar.gz
if [[ -d "$SRCDIR" ]]; then
    echo "$SRCDIR exists"
else
    echo "Download Dispatch"
    wget -q $SRCURL -O $DOWNLOAD_FILE
    rm -rf $SRCDIR
    mkdir -p $SRCDIR
    tar -xf $DOWNLOAD_FILE -C ./downloads
    mv ./downloads/swift-corelibs-libdispatch-$SWIFT_VERSION/* $SRCDIR
    rm -rf ./downloads/swift-corelibs-libdispatch-$SWIFT_VERSION
fi

# Download Foundation
DOWNLOAD_FILE=./downloads/foundation-${SWIFT_VERSION}.tar.gz
SRCDIR=$FOUNDATION_SRCDIR
SRCURL=https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/$SWIFT_VERSION.tar.gz
if [[ -d "$SRCDIR" ]]; then
    echo "$SRCDIR exists"
else
    echo "Download Foundation"
    wget -q $SRCURL -O $DOWNLOAD_FILE
    rm -rf $SRCDIR
    mkdir -p $SRCDIR
    tar -xf $DOWNLOAD_FILE -C ./downloads
    mv ./downloads/swift-corelibs-foundation-$SWIFT_VERSION/* $SRCDIR
fi

# Download XCTest
DOWNLOAD_FILE=./downloads/xctest-${SWIFT_VERSION}.tar.gz
SRCDIR=$XCTEST_SRCDIR
SRCURL=https://github.com/apple/swift-corelibs-xctest/archive/refs/tags/$SWIFT_VERSION.tar.gz
if [[ -d "$SRCDIR" ]]; then
    echo "$SRCDIR exists"
else
    echo "Download XCTest"
    wget -q $SRCURL -O $DOWNLOAD_FILE
    rm -rf $SRCDIR
    mkdir -p $SRCDIR
    tar -xf $DOWNLOAD_FILE -C ./downloads
    mv ./downloads/swift-corelibs-xctest-$SWIFT_VERSION/* $SRCDIR
    rm -rf ./downloads/swift-corelibs-xctest-$SWIFT_VERSION/
fi

# Download LLVM
DOWNLOAD_FILE=./downloads/llvm-${SWIFT_VERSION}.tar.gz
SRCDIR=$LLVM_SRCDIR
SRCURL=https://github.com/apple/llvm-project/archive/refs/tags/$SWIFT_VERSION.tar.gz
if [[ -d "$SRCDIR" ]]; then
    echo "$SRCDIR exists"
else
    echo "Download LLVM"
    wget -q $SRCURL -O $DOWNLOAD_FILE
    rm -rf $SRCDIR
    mkdir -p $SRCDIR
    tar -xf $DOWNLOAD_FILE -C ./downloads
    mv ./downloads/llvm-project-$SWIFT_VERSION/* $LLVM_SRCDIR
    rm -rf ./downloads/llvm-project-$SWIFT_VERSION/
fi