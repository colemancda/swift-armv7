# Configurable
source .config
source swift-define

set -e

# Build paths
LIBDISPATCH_SRCDIR=$SRC_ROOT/downloads/swift-corelibs-libdispatch-swift-${SWIFT_VERSION}-RELEASE
LIBDISPATCH_BUILDDIR=$SRC_ROOT/build/libdispatch-armv7
LIBDISPATCH_INSTALL_PREFIX=$SRC_ROOT/build/libdispatch-armv7-install/usr

# Compilation flags
EXTRA_INCLUDE_FLAGS="-I${STAGING_DIR}/usr/include/c++/10 -I${STAGING_DIR}/usr/include"
RUNTIME_FLAGS="-w -fuse-ld=lld --sysroot=${STAGING_DIR} -target armv7-unknown-linux-gnueabihf -march=armv7-a -mthumb -mfpu=neon -mfloat-abi=hard -B${STAGING_DIR}/usr/lib -B${STAGING_DIR}/lib -B${STAGING_DIR}/usr/lib/arm-linux-gnueabihf -B${STAGING_DIR}/lib/arm-linux-gnueabihf -B${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10"
LINK_FLAGS="--sysroot=${STAGING_DIR} -target armv7-unknown-linux-gnueabihf -march=armv7-a -mthumb -mfpu=neon -mfloat-abi=hard -latomic"

SWIFTC_FLAGS="-target armv7-unknown-linux-gnueabihf -use-ld=lld \
-resource-dir ${STAGING_DIR}/usr/lib/swift \
-Xclang-linker -B${STAGING_DIR}/usr/lib \
-Xclang-linker -B${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10 \
-Xcc -I${STAGING_DIR}/usr/include \
-Xcc -I${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10/include \
-L${STAGING_DIR}/lib \
-L${STAGING_DIR}/usr/lib \
-L${STAGING_DIR}/usr/lib/swift \
-L${STAGING_DIR}/usr/lib/swift/linux \
-L${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10 \
-sdk ${STAGING_DIR} \
"

echo "Create Dispatch build folder ${SWIFT_BUILDDIR}"
mkdir -p $LIBDISPATCH_BUILDDIR
mkdir -p $LIBDISPATCH_INSTALL_PREFIX

echo "Configure Dispatch"
rm -rf $LIBDISPATCH_BUILDDIR/CMakeCache.txt
LIBS="-latomic" cmake -S $LIBDISPATCH_SRCDIR -B $LIBDISPATCH_BUILDDIR -G Ninja \
		-DCMAKE_INSTALL_PREFIX=${LIBDISPATCH_INSTALL_PREFIX} \
		-DBUILD_TESTING=OFF \
		-DBUILD_SHARED_LIBS=ON \
		-DCMAKE_BUILD_TYPE=${SWIFT_BUILD_CONFIGURATION} \
        -DCMAKE_C_COMPILER=${SWIFT_NATIVE_PATH}/clang \
        -DCMAKE_CXX_COMPILER=${SWIFT_NATIVE_PATH}/clang++ \
        -DCMAKE_C_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
        -DCMAKE_CXX_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
        -DCMAKE_C_LINK_FLAGS="${LINK_FLAGS}" \
        -DCMAKE_CXX_LINK_FLAGS="${LINK_FLAGS}" \
    	-DENABLE_SWIFT=YES \
		-DCMAKE_Swift_FLAGS="${SWIFTC_FLAGS}" \
		-DCMAKE_Swift_FLAGS_DEBUG="" \
		-DCMAKE_Swift_FLAGS_RELEASE="" \
		-DCMAKE_Swift_FLAGS_RELWITHDEBINFO="" \

echo "Build Dispatch"
(cd $LIBDISPATCH_BUILDDIR && ninja)

echo "Install Dispatch"
(cd $LIBDISPATCH_BUILDDIR && ninja install)

echo "Install to Debian sysroot"
mv ${LIBDISPATCH_INSTALL_PREFIX}/lib/swift/linux/"$(uname -m)" ${LIBDISPATCH_INSTALL_PREFIX}/lib/swift/linux/armv7
sudo cp -rf ${LIBDISPATCH_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/
