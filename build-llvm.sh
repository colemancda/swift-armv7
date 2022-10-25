#!/bin/bash
set -e
source swift-define

echo "Create LLVM build folder ${LLVM_BUILDDIR}"
mkdir -p $LLVM_BUILDDIR
mkdir -p $LLVM_INSTALL_PREFIX

echo "Build LLVM"
cd $SWIFT_SRCDIR
export SKIP_XCODE_VERSION_CHECK=1
export SWIFT_NATIVE_SWIFT_TOOLS_PATH=$SWIFT_NATIVE_PATH
export SWIFT_NATIVE_CLANG_TOOLS_PATH=$SWIFT_NATIVE_PATH
export CC=$SWIFT_NATIVE_PATH/clang

./utils/build-script -RA --build-swift-tools=0 \
    --skip-early-swift-driver --skip-build-llvm --skip-build-cmark  \
    --native-swift-tools-path=$SWIFT_NATIVE_PATH \
    --native-clang-tools-path=$SWIFT_NATIVE_PATH \
    --swift-install-components='clang-resource-dir-symlink;license;stdlib;sdk-overlay' \
    --install-swift \
    --cross-compile-append-host-target-to-destdir=False --build-swift-dynamic-stdlib \
    --build-dir=$SRC_ROOT/build \
    --workspace=$SRC_ROOT/downloads \
