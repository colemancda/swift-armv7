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

./utils/build-script -RA \
    --reconfigure \
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
    --swift-install-components='autolink-driver;compiler;clang-resource-dir-symlink;swift-remote-mirror;parser-lib;license;sourcekit-inproc;stdlib;sdk-overlay' \
    --install-swift \
    --install-cmark \
    --install-destdir=$SWIFT_INSTALL_PREFIX \
    --build-dir=$SRC_ROOT/build \
    --workspace=$SRC_ROOT/downloads \
    --extra-cmake-options=" \
        -DCMAKE_C_FLAGS=\"${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}\" \
        -DCMAKE_CXX_FLAGS=\"${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}\" \
        -DCMAKE_C_LINK_FLAGS=\"${LINK_FLAGS}\" \
        -DCMAKE_CXX_LINK_FLAGS=\"${LINK_FLAGS}\" \
        -DCMAKE_SYSROOT=\"$STAGING_DIR\" \
        -DCMAKE_LINKER=/usr/bin/ld.lld \
        -DSWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_PATH=${STAGING_DIR} \
        -DSWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_LIBC_INCLUDE_DIRECTORY=${STAGING_DIR}/usr/include \
        -DSWIFT_USE_LINKER=lld \
        -DLLVM_USE_LINKER=lld \
        -DZLIB_LIBRARY=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libz.so \
        -DZLIB_INCLUDE_DIR=${STAGING_DIR}/usr/include \
        -DSWIFT_PATH_TO_CMARK_BUILD=${SRC_ROOT}/downloads/build/Ninja-Release/cmark-linux-armv7 \
        -DCMAKE_CROSSCOMPILING=\"TRUE\" \
    "
