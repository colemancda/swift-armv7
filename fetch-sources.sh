#!/bin/bash
set -e
source swift-define

mkdir -p ./downloads
mkdir -p ./build

# Fetch sources
cd ./downloads
if [[ -d "$SWIFT_SRCDIR" ]]; then
    echo "$SWIFT_SRCDIR exists"
else
    echo "Checkout Swift"
    git clone https://github.com/apple/swift.git
    ./swift/utils/update-checkout --clone --tag $SWIFT_VERSION

    # Apply patches
    echo "Apply CXX interop patch"
    patch -d $SWIFT_SRCDIR -p1 <$SRC_ROOT/patches/0001-Swift-fix-find-libstdc++-for-cxx-interop.patch
fi
