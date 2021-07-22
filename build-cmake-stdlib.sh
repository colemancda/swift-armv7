INSTALL_PREFIX=/home/$USER/Developer/swift-armv7/swift-armv7-release
STAGING_DIR_TARGET=/home/$USER/bullseye-armv7
SWIFT_NATIVE_PATH=/home/$USER/Downloads/swift-5.4.1-RELEASE-ubuntu20.04
HOST_LLVM_PATH=$STAGING_DIR_TARGET/usr/lib/llvm-11
LLVM_MAIN_SRC_DIR=/home/$USER/Developer/swift-armv7/llvm-project/llvm

TARGET_FLAGS="--sysroot=${STAGING_DIR_TARGET} -target armv7-unknown-linux-gnueabihf -march=armv7-a -mthumb -mfpu=neon -mfloat-abi=hard"
SWIFT_CXX_VERSION=10
EXTRA_INCLUDE_FLAGS="-I${STAGING_DIR_TARGET}/usr/include/c++/${SWIFT_CXX_VERSION} -I${STAGING_DIR_TARGET}/usr/include"
RUNTIME_FLAGS="-w -fuse-ld=lld ${TARGET_FLAGS} -B${STAGING_DIR_TARGET}/usr/lib/c++/${SWIFT_CXX_VERSION} -B${STAGING_DIR_TARGET}/usr/lib -B${STAGING_DIR_TARGET}/lib"
LINK_FLAGS="${TARGET_FLAGS} -latomic"
BUILD_DIR=./build/swift-stdlib-armv7

echo "Create Swift StdLib build folder"
rm -rf $BUILD_DIR
mkdir $BUILD_DIR

echo "Configure Swift"
cmake -S ./swift -B $BUILD_DIR -G Ninja  \
    -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON \
    -DSWIFT_USE_LINKER=lld \
    -DCMAKE_C_COMPILER=$SWIFT_NATIVE_PATH/usr/bin/clang \
    -DCMAKE_CXX_COMPILER=$SWIFT_NATIVE_PATH/usr/bin/clang++ \
    -DCMAKE_C_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
    -DCMAKE_CXX_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
    -DCMAKE_C_LINK_FLAGS="${LINK_FLAGS}" \
    -DCMAKE_CXX_LINK_FLAGS="${LINK_FLAGS}" \
    -DLLVM_USE_LINKER=lld \
    -DCMAKE_SYSTEM_PROCESSOR=armv7-a \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_DIR=${HOST_LLVM_PATH}/cmake \
    -DLLVM_BUILD_LIBRARY_DIR=${HOST_LLVM_PATH}/lib \
    -DLLVM_MAIN_INCLUDE_DIR=/home/$USER/Developer/swift-armv7/llvm-project/llvm/include \
    -DLLVM_MAIN_SRC_DIR=/home/$USER/Developer/swift-armv7/llvm-project/llvm \
    -DSWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER=ON \
    -DSWIFT_NATIVE_CLANG_TOOLS_PATH=$SWIFT_NATIVE_PATH/usr/bin \
    -DSWIFT_NATIVE_SWIFT_TOOLS_PATH=$SWIFT_NATIVE_PATH/usr/bin \
    -DSWIFT_BUILD_AST_ANALYZER=OFF  \
    -DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=ON  \
    -DSWIFT_BUILD_DYNAMIC_STDLIB=ON \
    -DSWIFT_BUILD_REMOTE_MIRROR=OFF \
    -DSWIFT_BUILD_SOURCEKIT=OFF \
    -DSWIFT_BUILD_STDLIB_EXTRA_TOOLCHAIN_CONTENT=OFF \
    -DSWIFT_BUILD_SYNTAXPARSERLIB=OFF \
    -DSWIFT_BUILD_REMOTE_MIRROR=OFF \
    -DSWIFT_ENABLE_SOURCEKIT_TESTS=OFF \
    -DSWIFT_INCLUDE_DOCS=OFF \
    -DSWIFT_INCLUDE_TOOLS=OFF \
    -DSWIFT_INCLUDE_TESTS=OFF \
    -DSWIFT_HOST_VARIANT_ARCH=armv7 \
    -DSWIFT_SDKS=LINUX \
    -DSWIFT_SDK_LINUX_ARCH_armv7_PATH=${STAGING_DIR_TARGET}  \
    -DSWIFT_SDK_LINUX_ARCH_armv7_LIBC_INCLUDE_DIRECTORY=${STAGING_DIR_TARGET}/usr/include  \
    -DSWIFT_SDK_LINUX_ARCH_armv7_LIBC_ARCHITECTURE_INCLUDE_DIRECTORY=${STAGING_DIR_TARGET}/usr/include/arm-linux-gnueabihf \
    -DSWIFT_LINUX_armv7_ICU_I18N=${STAGING_DIR_TARGET}/usr/lib/arm-linux-gnueabihf/libicui18n.so \
    -DSWIFT_LINUX_armv7_ICU_UC=${STAGING_DIR_TARGET}/usr/lib/arm-linux-gnueabihf/libicuuc.so \
    -DICU_I18N_LIBRARIES=${STAGING_DIR_TARGET}/usr/lib/arm-linux-gnueabihf/libicui18n.so \
    -DICU_UC_LIBRARIES=${STAGING_DIR_TARGET}/usr/lib/arm-linux-gnueabihf/libicuuc.so \

echo "Build Swift StdLib"
cd $BUILD_DIR
ninja

echo "Copy Swift StdLib"
rm -rf $INSTALL_PREFIX/usr/lib/swift
mkdir $INSTALL_PREFIX/usr/lib/swift
mkdir $INSTALL_PREFIX/usr/lib/swift/linux

cp -rf ./lib/swift/shims $INSTALL_PREFIX/usr/lib/swift/

cp ./lib/swift/linux/libswiftCore.so $INSTALL_PREFIX/usr/lib/swift/linux/
cp ./lib/swift/linux/libswiftRemoteMirror.so $INSTALL_PREFIX/usr/lib/swift/linux/
cp ./lib/swift/linux/libswiftSwiftOnoneSupport.so $INSTALL_PREFIX/usr/lib/swift/linux/
cp -rf ./lib/swift/linux/Glibc.swiftmodule $INSTALL_PREFIX/usr/lib/swift/linux/
cp -rf ./lib/swift/linux/Swift.swiftmodule $INSTALL_PREFIX/usr/lib/swift/linux/
cp -rf ./lib/swift/linux/SwiftOnoneSupport.swiftmodule $INSTALL_PREFIX/usr/lib/swift/linux/

mkdir $INSTALL_PREFIX/usr/lib/swift/linux/armv7
cp ./lib/swift/linux/armv7/glibc.modulemap $INSTALL_PREFIX/usr/lib/swift/linux/armv7/
cp ./lib/swift/linux/armv7/swiftrt.o $INSTALL_PREFIX/usr/lib/swift/linux/armv7/
