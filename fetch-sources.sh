source .config
source swift-define

mkdir -p ./downloads
mkdir -p ./build

# Download Swift
DOWNLOAD_FILE=./downloads/swift-${SWIFT_VERSION}.tar.gz
SRCDIR=./downloads/swift-swift-${SWIFT_VERSION}-RELEASE
SRCURL=https://github.com/apple/swift/archive/refs/tags/swift-${SWIFT_VERSION}-RELEASE.tar.gz
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
patch ./downloads/swift-swift-${SWIFT_VERSION}-RELEASE/stdlib/public/SwiftShims/RefCount.h $DOWNLOAD_FILE 

DOWNLOAD_FILE=./downloads/swift-stdlib-float16.patch
SRCURL=https://gist.githubusercontent.com/colemancda/ed295f963493726b1c01a6bc97945a3d/raw/8392d963c96ee5c910b816734afca4295a7e09c7/Float16.patch
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download ${DOWNLOAD_FILE}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
patch ./downloads/swift-swift-${SWIFT_VERSION}-RELEASE/stdlib/public/runtime/Float16Support.cpp $DOWNLOAD_FILE 

# Download Dispatch
DOWNLOAD_FILE=./downloads/libdispatch-${SWIFT_VERSION}.tar.gz
SRCDIR=./downloads/swift-corelibs-libdispatch-swift-${SWIFT_VERSION}-RELEASE
SRCURL=https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/swift-${SWIFT_VERSION}-RELEASE.tar.gz
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
patch ./downloads/swift-corelibs-libdispatch-swift-${SWIFT_VERSION}-RELEASE/src/shims/yield.c $DOWNLOAD_FILE 

# Download Foundation
DOWNLOAD_FILE=./downloads/foundation-${SWIFT_VERSION}.tar.gz
SRCDIR=./downloads/swift-corelibs-foundation-swift-${SWIFT_VERSION}-RELEASE
SRCURL=https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/swift-${SWIFT_VERSION}-RELEASE.tar.gz
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download Foundation ${SWIFT_VERSION}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
rm -rf $SRCDIR
mkdir -p $SRCDIR
tar -xf $DOWNLOAD_FILE -C ./downloads

