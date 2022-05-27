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

# Apply Swift patches
echo "Apply Swift patches"
DOWNLOAD_FILE=./downloads/swift-stdlib-refcount.patch
SRCURL=https://gist.githubusercontent.com/colemancda/ed295f963493726b1c01a6bc97945a3d/raw/8392d963c96ee5c910b816734afca4295a7e09c7/RefCount.patch
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download ${DOWNLOAD_FILE}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
patch ./downloads/swift-$SWIFT_VERSION/stdlib/public/SwiftShims/RefCount.h $DOWNLOAD_FILE 

DOWNLOAD_FILE=./downloads/swift-stdlib-float16.patch
SRCURL=https://gist.githubusercontent.com/colemancda/ed295f963493726b1c01a6bc97945a3d/raw/8392d963c96ee5c910b816734afca4295a7e09c7/Float16.patch
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download ${DOWNLOAD_FILE}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
patch ./downloads/swift-$SWIFT_VERSION/stdlib/public/runtime/Float16Support.cpp $DOWNLOAD_FILE

DOWNLOAD_FILE=./downloads/swift-stdlib-AtomicWaitQueue.patch
SRCURL=https://gist.githubusercontent.com/colemancda/d88a775f2bf3e234f4fa705c46b66b37/raw/1d8d54f23f5564f847ab39c65b59d287bba4f333/swift-5.6-AtomicWaitQueue.patch
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download ${DOWNLOAD_FILE}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
patch ./downloads/swift-$SWIFT_VERSION/include/swift/Runtime/AtomicWaitQueue.h $DOWNLOAD_FILE

DOWNLOAD_FILE=./downloads/swift-stdlib-HeapObject.patch
SRCURL=https://gist.github.com/colemancda/d88a775f2bf3e234f4fa705c46b66b37/raw/1d8d54f23f5564f847ab39c65b59d287bba4f333/swift-5.6-HeapObject-cxx-newObject.patch
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download ${DOWNLOAD_FILE}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
patch ./downloads/swift-$SWIFT_VERSION/include/swift/Runtime/HeapObject.h $DOWNLOAD_FILE

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

# Apply Dispatch patches
echo "Apply Dispatch patches"
DOWNLOAD_FILE=./downloads/libdispatch-yield.patch
SRCURL=https://gist.githubusercontent.com/colemancda/a7c116250ceb601da5b408a4fd36f239/raw/7de75208472e5ce04954715ea5b59d7980ce57ff/arm-yield.patch
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download ${DOWNLOAD_FILE}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
patch ./downloads/swift-corelibs-libdispatch-$SWIFT_VERSION/src/shims/yield.c $DOWNLOAD_FILE 

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
