SWIFT_RELEASE=swift-5.4.1-RELEASE

echo "Checkout Swift at ${SWIFT_RELEASE}"
git clone https://github.com/apple/swift.git
cd ./swift
git checkout SWIFT_RELEASE
cd ../

git clone https://github.com/apple/swift-corelibs-libdispatch.git
cd ./swift-corelibs-libdispatch
git checkout SWIFT_RELEASE
cd ../

git clone https://github.com/apple/swift-corelibs-foundation.git
cd ./swift-corelibs-foundation
git checkout SWIFT_RELEASE
cd ../