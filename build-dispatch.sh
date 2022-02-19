# Configurable
source .config
source swift-define

set -e

# Build paths
LIBDISPATCH_SRCDIR=$SRC_ROOT/build/swift-corelibs-libdispatch-swift-${SWIFT_VERSION}-RELEASE
LIBDISPATCH_BUILDDIR=$SRC_ROOT/build/libdisaptch-armv7

echo "Dispatch build folder ${LIBDISPATCH_BUILDDIR}"
rm -rf $LIBDISPATCH_BUILDDIR
mkdir -p $LIBDISPATCH_BUILDDIR

echo "Configure Dispatch"
rm -rf $LIBDISPATCH_BUILDDIR/CMakeCache.txt
cmake -S $LIBDISPATCH_SRCDIR -B $LIBDISPATCH_BUILDDIR -G Ninja \
    -DCMAKE_INSTALL_PREFIX="/usr" \
		-DCMAKE_COLOR_MAKEFILE=OFF \
		-DBUILD_DOC=OFF \
		-DBUILD_DOCS=OFF \
		-DBUILD_EXAMPLE=OFF \
		-DBUILD_EXAMPLES=OFF \
		-DBUILD_TEST=OFF \
		-DBUILD_TESTS=OFF \
		-DBUILD_TESTING=OFF \
		-DBUILD_SHARED_LIBS=ON \
		-DCMAKE_BUILD_TYPE=Release \
    	-DCMAKE_C_COMPILER=${SWIFT_NATIVE_PATH}/clang \
    	-DCMAKE_CXX_COMPILER=${SWIFT_NATIVE_PATH}/clang++ \
		-DCMAKE_C_FLAGS="-w -fuse-ld=lld -target ${SWIFT_TARGET_NAME} --sysroot ${STAGING_DIR} -march=armv7-a -mfpu=neon -mfloat-abi=hard -I${STAGING_DIR}/usr/include -I${STAGING_DIR}/usr/include/arm-linux-gnueabihf -B${STAGING_DIR}/usr/lib -B${STAGING_DIR}/usr/lib/arm-linux-gnueabihf -B${STAGING_DIR}/lib -B${STAGING_DIR}/lib/arm-linux-gnueabihf -B${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10 -L${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10 " \
    	-DCMAKE_C_LINK_FLAGS="-target ${SWIFT_TARGET_NAME} --sysroot ${STAGING_DIR} -march=armv7-a -mfpu=neon -mfloat-abi=hard " \
    	-DCMAKE_CXX_FLAGS="-w -fuse-ld=lld -target ${SWIFT_TARGET_NAME} --sysroot ${STAGING_DIR} -march=armv7-a -mfpu=neon -mfloat-abi=hard -I${STAGING_DIR}/usr/include -I${STAGING_DIR}/usr/include/arm-linux-gnueabihf -B${STAGING_DIR}/usr/lib -B${STAGING_DIR}/usr/lib/arm-linux-gnueabihf -B${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10 -L${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10" \
		-DCMAKE_CXX_LINK_FLAGS="-target ${SWIFT_TARGET_NAME} --sysroot ${STAGING_DIR} -march=armv7-a -mfpu=neon -mfloat-abi=hard " \

echo "Build Dispatch"
(cd $SWIFT_BUILDDIR && ninja)
