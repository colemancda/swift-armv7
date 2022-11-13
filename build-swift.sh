#!/bin/bash
set -e
source swift-define

echo "Create Swift build folder ${SWIFT_BUILDDIR}"
mkdir -p $SWIFT_BUILDDIR
mkdir -p $SWIFT_INSTALL_PREFIX

echo "Build Swift compiler"
cd $SWIFT_SRCDIR
export SKIP_XCODE_VERSION_CHECK=1
export SWIFT_NATIVE_SWIFT_TOOLS_PATH=$SWIFT_NATIVE_PATH
export SWIFT_NATIVE_CLANG_TOOLS_PATH=$SWIFT_NATIVE_PATH
export CC=$SWIFT_NATIVE_PATH/clang
export CFLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}"
export CXXFLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}"
export LDFLAGS="${LINK_FLAGS}"

# Create symbolic link
mkdir -p ${SWIFT_INSTALL_PREFIX}/usr/lib/swift/linux/${SWIFT_TARGET_ARCH}
ln -s ${SWIFT_INSTALL_PREFIX}/usr/lib/swift/linux/${SWIFT_TARGET_ARCH} ${SWIFT_INSTALL_PREFIX}/usr/lib/swift/linux/"$(uname -m)"

# Copy SwiftPM destination file
cp -rf $SWIFTPM_DESTINATION_FILE $SWIFT_INSTALL_PREFIX/usr/swiftpm.json

# Build Swift
./utils/build-script -RA \
    --skip-early-swift-driver \
    --bootstrapping=off \
    --build-toolchain-only \
    --skip-local-build \
    --skip-local-host-install \
    --native-swift-tools-path=$SWIFT_NATIVE_PATH \
    --native-clang-tools-path=$SWIFT_NATIVE_PATH \
    --cross-compile-hosts=linux-armv7 \
    --cross-compile-deps-path=$STAGING_DIR \
    --cross-compile-append-host-target-to-destdir=False \
    --swift-install-components="${SWIFT_COMPONENTS}" \
    --install-swift \
    --install-cmark \
    --libdispatch --foundation --xctest \
    --install-foundation --install-libdispatch --install-xctest \
    --llbuild --swiftpm \
    --install-llbuild --install-swiftpm \
    --install-destdir=$SWIFT_INSTALL_PREFIX \
    --build-dir=$SRC_ROOT/build \
    --workspace=$SRC_ROOT/downloads \
    --common-swift-flags="${SWIFTC_FLAGS}" \
    --extra-cmake-options="${EXTRA_CMAKE_OPTIONS}" \

echo "Fix Swift modules"
rm -rf ${SWIFT_INSTALL_PREFIX}/usr/lib/swift/linux/"$(uname -m)"
rm -rf ${SWIFT_INSTALL_PREFIX}/usr/lib/swift_static
