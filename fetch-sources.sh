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
fi
