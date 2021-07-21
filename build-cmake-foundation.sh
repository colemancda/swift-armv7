STAGING_DIR_TARGET=/home/$USER/bullseye-armv7
SWIFT_NATIVE_PATH=/home/$USER/Downloads/swift-5.4.1-RELEASE-ubuntu20.04
EXTRA_INCLUDE_FLAGS="-I${STAGING_DIR_TARGET}/usr/include/c++/10 -I${STAGING_DIR_TARGET}/usr/include"
RUNTIME_FLAGS="-w -fuse-ld=lld --sysroot=${STAGING_DIR_TARGET} -target armv7-unknown-linux-gnueabihf -march=armv7-a -mthumb -mfpu=neon -mfloat-abi=hard -B${STAGING_DIR_TARGET}/usr/lib/c++/10 -B${STAGING_DIR_TARGET}/usr/lib -B${STAGING_DIR_TARGET}/lib"
LINK_FLAGS="-w --sysroot=${STAGING_DIR_TARGET} -target armv7-unknown-linux-gnueabihf -march=armv7-a -mthumb -mfpu=neon -mfloat-abi=hard -L${STAGING_DIR_TARGET}/usr/lib/swift/linux"
ASM_FLAGS="--sysroot=${STAGING_DIR_TARGET} -target armv7-unknown-linux-gnueabihf -march=armv7-a -mthumb -mfpu=neon -mfloat-abi=hard"
BUILD_DIR=./build/foundation-armv7
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

echo "Create Foundation build folder"
rm -rf $BUILD_DIR
mkdir $BUILD_DIR

echo "Configure Foundation"
cmake -S ./swift-corelibs-foundation -B $BUILD_DIR -G Ninja \
    -DCMAKE_C_COMPILER=$SWIFT_NATIVE_PATH/usr/bin/clang \
    -DCMAKE_C_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
    -DCMAKE_C_LINK_FLAGS="${LINK_FLAGS}" \
    -DCMAKE_ASM_FLAGS="${ASM_FLAGS}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_SYSTEM_PROCESSOR="armv7-a" \
    -DCMAKE_SYSTEM_NAME=Linux \
    -DCMAKE_Swift_FLAGS="${SWIFT_FLAGS}" \
    -DCF_DEPLOYMENT_SWIFT=ON \
    -Ddispatch_DIR="/home/coleman/Developer/swift-source/build/libdispatch-armv7/cmake/modules" \
    -DLIBXML2_LIBRARY=${STAGING_DIR_TARGET}/usr/lib/arm-linux-gnueabihf/libxml2.so.2.9.10 \
    -DLIBXML2_INCLUDE_DIR=${STAGING_DIR_TARGET}/usr/include/libxml2 \
    -DCURL_LIBRARY_RELEASE=${STAGING_DIR_TARGET}/usr/lib/arm-linux-gnueabihf/libcurl.so.4.7.0 \
    -DCURL_INCLUDE_DIR="${STAGING_DIR_TARGET}/usr/include" \
    -DICU_I18N_LIBRARY_RELEASE=${STAGING_DIR_TARGET}/usr/lib/arm-linux-gnueabihf/libicui18n.so \
    -DICU_UC_LIBRARY_RELEASE=${STAGING_DIR_TARGET}/usr/lib/arm-linux-gnueabihf/libicuuc.so \
    -DICU_INCLUDE_DIR="${STAGING_DIR_TARGET}/usr/include"
    
echo "Build Foundation"
cd $BUILD_DIR
ninja

