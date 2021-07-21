STAGING_DIR_TARGET=/home/$USER/bullseye-armv7
SWIFT_NATIVE_PATH=/home/$USER/Downloads/swift-5.4.1-RELEASE-ubuntu20.04
EXTRA_INCLUDE_FLAGS="-I${STAGING_DIR_TARGET}/usr/include/c++/10 -I${STAGING_DIR_TARGET}/usr/include"
RUNTIME_FLAGS="-w -fuse-ld=lld --sysroot=${STAGING_DIR_TARGET} -target armv7-unknown-linux-gnueabihf -march=armv7-a -mthumb -mfpu=neon -mfloat-abi=hard -B${STAGING_DIR_TARGET}/usr/lib/c++/10 -B${STAGING_DIR_TARGET}/usr/lib -B${STAGING_DIR_TARGET}/lib"
LINK_FLAGS="-w --sysroot=${STAGING_DIR_TARGET} -target armv7-unknown-linux-gnueabihf -march=armv7-a -mthumb -mfpu=neon -mfloat-abi=hard -L${STAGING_DIR_TARGET}/usr/lib/swift/linux"
BUILD_DIR=./build/libdispatch-armv7
TARGET_SYS="arm-linux-gnueabihf"
EXTRA_SWIFTC_FLAGS=""
SWIFT_FLAGS="-target armv7-unknown-linux-gnueabihf -use-ld=lld \
-resource-dir ${STAGING_DIR_TARGET}/usr/lib/swift \
-Xclang-linker -B${STAGING_DIR_TARGET}/usr/lib/c++/10 \
-Xclang-linker -B${STAGING_DIR_TARGET}/usr/lib \
-Xcc -I${STAGING_DIR_TARGET}/usr/include \
-Xcc -I${STAGING_DIR_TARGET}/usr/include/c++/10 \
-Xcc -I${STAGING_DIR_TARGET}/usr/lib/llvm-11/lib/clang/11.0.1/include \
-L${STAGING_DIR_TARGET} \
-L${STAGING_DIR_TARGET}/lib \
-L${STAGING_DIR_TARGET}/usr/lib \
-L${STAGING_DIR_TARGET}/usr/lib/swift \
-L${STAGING_DIR_TARGET}/usr/lib/swift/linux \
-L${STAGING_DIR_TARGET}/usr/lib/${TARGET_SYS}/current \
-sdk ${STAGING_DIR_TARGET} \
${EXTRA_SWIFTC_FLAGS} \
"

echo "Create Dispatch build folder"
rm -rf $BUILD_DIR
mkdir $BUILD_DIR

echo "Configure Dispatch"
cmake -S ./swift-corelibs-libdispatch -B $BUILD_DIR -G Ninja \
    -DCMAKE_C_COMPILER=$SWIFT_NATIVE_PATH/usr/bin/clang \
    -DCMAKE_CXX_COMPILER=$SWIFT_NATIVE_PATH/usr/bin/clang++ \
    -DCMAKE_C_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
    -DCMAKE_CXX_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
    -DCMAKE_C_LINK_FLAGS="${LINK_FLAGS}" \
    -DCMAKE_CXX_LINK_FLAGS="${LINK_FLAGS}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_SYSTEM_PROCESSOR="armv7-a" \
    -DCMAKE_SYSTEM_NAME=Linux \
    -DLibRT_LIBRARIES="${STAGING_DIR_TARGET}/lib/arm-linux-gnueabihf/librt.so" \
    -DENABLE_SWIFT=YES -DCMAKE_Swift_FLAGS="${SWIFT_FLAGS}" \

echo "Build Dispatch"
cd $BUILD_DIR
ninja

