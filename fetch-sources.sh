SWIFT_VERSION=5.5.3

mkdir -p ./downloads
mkdir -p ./build

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

# Apply patches
echo "Apply Swift patches"
DOWNLOAD_FILE=./downloads/swift-stdlib-refcount.diff
SRCURL=https://github.com/uraimo/buildSwiftOnARM/raw/master/swift.diffs/aarch32/RefCount.h.diff
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    echo "Download ${DOWNLOAD_FILE}"
    wget $SRCURL -O $DOWNLOAD_FILE
fi
patch ./downloads/swift-swift-${SWIFT_VERSION}-RELEASE/stdlib/public/SwiftShims/RefCount.h $DOWNLOAD_FILE 

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

