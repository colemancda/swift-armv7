#!/bin/bash
set -e
source swift-define

echo "Create Dispatch build folder ${FOUNDATION_BUILDDIR}"
mkdir -p $FOUNDATION_BUILDDIR
mkdir -p $FOUNDATION_INSTALL_PREFIX

echo "Configure Dispatch"
rm -rf $FOUNDATION_BUILDDIR/CMakeCache.txt
LIBS="-latomic" cmake -S $FOUNDATION_SRCDIR -B $FOUNDATION_BUILDDIR -G Ninja \
		-DCMAKE_INSTALL_PREFIX=${FOUNDATION_INSTALL_PREFIX} \
		-DBUILD_TESTING=OFF \
		-DBUILD_SHARED_LIBS=ON \
		-DCMAKE_BUILD_TYPE=${SWIFT_BUILD_CONFIGURATION} \
        -DCMAKE_C_COMPILER=${SWIFT_NATIVE_PATH}/clang \
        -DCMAKE_CXX_COMPILER=${SWIFT_NATIVE_PATH}/clang++ \
        -DCMAKE_C_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
        -DCMAKE_CXX_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
        -DCMAKE_C_LINK_FLAGS="${LINK_FLAGS}" \
        -DCMAKE_CXX_LINK_FLAGS="${LINK_FLAGS}" \
        -DCMAKE_ASM_FLAGS="${ASM_FLAGS}" \
    	-DCF_DEPLOYMENT_SWIFT=ON \
        -Ddispatch_DIR="${LIBDISPATCH_BUILDDIR}/cmake/modules" \
        -DLIBXML2_LIBRARY=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libxml2.so \
        -DLIBXML2_INCLUDE_DIR=${STAGING_DIR}/usr/include/libxml2 \
        -DCURL_LIBRARY_RELEASE=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libcurl.so \
        -DCURL_INCLUDE_DIR="${STAGING_DIR}/usr/include" \
        -DICU_I18N_LIBRARY_RELEASE=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libicui18n.so \
        -DICU_UC_LIBRARY_RELEASE=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libicuuc.so \
        -DICU_INCLUDE_DIR="${STAGING_DIR}/usr/include" \
		-DCMAKE_Swift_FLAGS="${SWIFTC_FLAGS}" \
		-DCMAKE_Swift_FLAGS_DEBUG="" \
		-DCMAKE_Swift_FLAGS_RELEASE="" \
		-DCMAKE_Swift_FLAGS_RELWITHDEBINFO="" \

echo "Build Foundation"
# Workaround Dispatch defined with cmake and module
rm -rf ${STAGING_DIR}/usr/lib/swift/dispatch
(cd $FOUNDATION_BUILDDIR && ninja)
# Restore Dispatch headers
cp -rf ${LIBDISPATCH_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/

echo "Install Foundation"
(cd $FOUNDATION_BUILDDIR && ninja install)

echo "Install to Debian sysroot"
mv ${FOUNDATION_INSTALL_PREFIX}/lib/swift/linux/"$(uname -m)" ${FOUNDATION_INSTALL_PREFIX}/lib/swift/linux/armv7
cp -rf ${FOUNDATION_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/
