#!/bin/bash
set -e
source swift-define

echo "Create Swift build folder ${SWIFT_BUILDDIR}"
mkdir -p $SWIFT_BUILDDIR
mkdir -p $SWIFT_INSTALL_PREFIX

echo "Build Swift"
cd $SWIFT_SRCDIR
export SKIP_XCODE_VERSION_CHECK=1
export SWIFT_NATIVE_SWIFT_TOOLS_PATH=$SWIFT_NATIVE_PATH
export SWIFT_NATIVE_CLANG_TOOLS_PATH=$SWIFT_NATIVE_PATH
export CC=$SWIFT_NATIVE_PATH/clang
export CFLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}"
export CXXFLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}"
export LDFLAGS="${LINK_FLAGS}"

./utils/build-script -RA --build-swift-tools=0 \
    --skip-early-swift-driver --skip-build-llvm --skip-build-cmark  \
    --skip-local-build \
    --native-swift-tools-path=$SWIFT_NATIVE_PATH \
    --native-clang-tools-path=$SWIFT_NATIVE_PATH \
    --cross-compile-hosts=linux-armv7 --cross-compile-deps-path=$STAGING_DIR \
    --swift-install-components='clang-resource-dir-symlink;license;stdlib;sdk-overlay' \
    --install-swift \
    --install-destdir=$SWIFT_INSTALL_PREFIX \
    --cross-compile-append-host-target-to-destdir=False --build-swift-dynamic-stdlib \
    --build-dir=$SRC_ROOT/build \
    --workspace=$SRC_ROOT/downloads \
    --stdlib-deployment-targets="linux-armv7" \
    --extra-cmake-options=" \
        -DCMAKE_C_FLAGS=\"${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}\" \
        -DCMAKE_CXX_FLAGS=\"${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}\" \
        -DCMAKE_C_LINK_FLAGS=\"${LINK_FLAGS}\" \
        -DCMAKE_CXX_LINK_FLAGS=\"${LINK_FLAGS}\" \
        -DCMAKE_LINKER=/usr/bin/ld.lld \
        -DSWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_PATH=${STAGING_DIR} \
        -DSWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_LIBC_INCLUDE_DIRECTORY=${STAGING_DIR}/usr/include \
        -DSWIFT_USE_LINKER=lld \
        -DLLVM_USE_LINKER=lld \
        -DZLIB_LIBRARY=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libz.so \
        -DZLIB_INCLUDE_DIR=${STAGING_DIR}/usr/include \
    "

echo "Install to Debian sysroot"
cp -rf ${SWIFT_INSTALL_PREFIX}/* ${STAGING_DIR}/
