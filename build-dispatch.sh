#!/bin/bash
set -e
source swift-define

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
cp -rf ${LIBDISPATCH_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/
