SWIFT_VERSION=5.5.3

echo "Download Swift ${SWIFT_VERSION}"

mkdir -p ./downloads
mkdir -p ./build

DOWNLOAD_FILE=./downloads/swift-${SWIFT_VERSION}.tar.gz
SRCDIR=./build/swift-${SWIFT_VERSION}
SRCURL=https://github.com/apple/swift/archive/refs/tags/swift-${SWIFT_VERSION}-RELEASE.tar.gz
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    wget $SRCURL -O $DOWNLOAD_FILE
fi
rm -rf $SRCDIR
mkdir -p $SRCDIR
tar -xf $DOWNLOAD_FILE -C $SRCDIR

# Apply patches


DOWNLOAD_FILE=./downloads/libdispatch-${SWIFT_VERSION}.tar.gz
SRCDIR=./build/libdispatch-${SWIFT_VERSION}
SRCURL=https://github.com/apple/swift-corelibs-libdispatch/archive/refs/tags/swift-${SWIFT_VERSION}-RELEASE.tar.gz
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    wget $SRCURL -O $DOWNLOAD_FILE
fi
rm -rf $SRCDIR
mkdir -p $SRCDIR
tar -xf $DOWNLOAD_FILE -C $SRCDIR

DOWNLOAD_FILE=./downloads/foundation-${SWIFT_VERSION}.tar.gz
SRCDIR=./build/foundation-${SWIFT_VERSION}
SRCURL=https://github.com/apple/swift-corelibs-foundation/archive/refs/tags/swift-${SWIFT_VERSION}-RELEASE.tar.gz
if test -f "$DOWNLOAD_FILE"; then
    echo "$DOWNLOAD_FILE exists"
else
    wget $SRCURL -O $DOWNLOAD_FILE
fi
mkdir -p $SRCDIR
tar -xf $DOWNLOAD_FILE -C $SRCDIR

