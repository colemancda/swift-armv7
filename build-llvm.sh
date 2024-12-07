#!/bin/bash
set -e
source swift-define

echo "Create LLVM build folder ${LLVM_BUILDDIR}"
mkdir -p $LLVM_BUILDDIR

echo "Configure LLVM"
cd $LLVM_BUILDDIR
cmake -S $LLVM_SRCDIR/llvm -B $LLVM_BUILDDIR -G Ninja \
        -DCMAKE_INSTALL_PREFIX=${LLVM_INSTALL_PREFIX} \
        -DCMAKE_C_COMPILER=$SWIFT_NATIVE_PATH/clang \
        -DCMAKE_CXX_COMPILER=$SWIFT_NATIVE_PATH/clang++ \
        -DLLVM_TARGETS_TO_BUILD="X86;ARM;AArch64" \
        -DLLVM_ENABLE_PROJECTS="llvm" \
        -DCMAKE_BUILD_TYPE=Release
