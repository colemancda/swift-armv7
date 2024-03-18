#!/bin/bash
set -e
source swift-define

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

./utils/build-script -RA --build-swift-tools=0 --swift-enable-backtracing=0 \
    --reconfigure --build-toolchain-only \
    --enable-experimental-cxx-interop=0 --enable-cxx-interop-swift-bridging-header=0 \
    --swift-threading-package=c11 --swift-stdlib-supports-backtrace-reporting=0 \
    --skip-early-swift-driver --skip-early-swiftsyntax --skip-build-llvm --skip-build-cmark  \
    --skip-local-build --skip-local-host-install \
    --native-swift-tools-path=$SWIFT_NATIVE_PATH \
    --native-clang-tools-path=$SWIFT_NATIVE_PATH \
    --cross-compile-hosts=linux-armv7 --cross-compile-deps-path=$STAGING_DIR \
    --cross-compile-append-host-target-to-destdir=False \
    --swift-install-components='clang-resource-dir-symlink;license;stdlib;sdk-overlay' \
    --install-swift --install-swiftsyntax \
    --libdispatch --foundation --xctest \
    --install-foundation --install-libdispatch --install-xctest \
    --install-destdir=$SWIFT_INSTALL_PREFIX \
    --workspace=$WORKSPACE_DIR \
    --common-swift-flags="${SWIFTC_FLAGS}" \
    --extra-cmake-options="${EXTRA_CMAKE_OPTIONS}"

echo "Fix Swift modules"
rm -rf ${SWIFT_INSTALL_PREFIX}/usr/lib/swift/linux/"$(uname -m)"
mkdir -p ${SWIFT_INSTALL_PREFIX}/usr/lib/swift_static/linux/${SWIFT_TARGET_ARCH}
cp -rf ${SWIFT_INSTALL_PREFIX}/usr/lib/swift_static/linux/"$(uname -m)"/* ${SWIFT_INSTALL_PREFIX}/usr/lib/swift_static/linux/${SWIFT_TARGET_ARCH}/
rm -rf ${SWIFT_INSTALL_PREFIX}/usr/lib/swift_static/linux/"$(uname -m)"

echo "Install to Debian sysroot"
cp -rf ${SWIFT_INSTALL_PREFIX}/* ${STAGING_DIR}/ 