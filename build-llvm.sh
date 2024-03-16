#!/bin/bash
set -e
source swift-define

echo "Build LLVM"
cd $SWIFT_SRCDIR
export SKIP_XCODE_VERSION_CHECK=1
export SWIFT_NATIVE_SWIFT_TOOLS_PATH=$SWIFT_NATIVE_PATH
export SWIFT_NATIVE_CLANG_TOOLS_PATH=$SWIFT_NATIVE_PATH
export CC=$SWIFT_NATIVE_PATH/clang
export CFLAGS="-fPIC"

./utils/build-script -RA --build-swift-tools=0 --swift-enable-backtracing=0 \
    --swift-threading-package=c11 --swift-stdlib-supports-backtrace-reporting=0 \
    --skip-early-swift-driver --skip-early-swiftsyntax \
    --skip-build-llvm --skip-build-cmark --skip-build-swift \
    --native-swift-tools-path=$SWIFT_NATIVE_PATH \
    --native-clang-tools-path=$SWIFT_NATIVE_PATH \
    --swift-install-components='clang-resource-dir-symlink;license;stdlib;sdk-overlay' \
    --install-swift --install-swiftsyntax \
    --cross-compile-append-host-target-to-destdir=False --build-swift-dynamic-stdlib \
    --workspace=$WORKSPACE_DIR
