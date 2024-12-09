#!/bin/bash
set -e
source swift-define

echo "Create swift-testing build folder ${SWIFT_TESTING_BUILDDIR}"
mkdir -p $SWIFT_TESTING_BUILDDIR
rm -rf $SWIFT_TESTING_INSTALL_PREFIX
mkdir -p $SWIFT_TESTING_INSTALL_PREFIX

echo "Configure swift-testing"
rm -rf $SWIFT_TESTING_BUILDDIR/CMakeCache.txt
LIBS="-latomic" cmake -S $SWIFT_TESTING_SRCDIR -B $SWIFT_TESTING_BUILDDIR -G Ninja \
        -DCMAKE_INSTALL_PREFIX=${SWIFT_TESTING_INSTALL_PREFIX} \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_BUILD_TYPE=${SWIFT_BUILD_CONFIGURATION} \
        -DCMAKE_C_COMPILER=${SWIFT_NATIVE_PATH}/clang \
        -DCMAKE_CXX_COMPILER=${SWIFT_NATIVE_PATH}/clang++ \
        -DCMAKE_C_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
        -DCMAKE_CXX_FLAGS="${RUNTIME_FLAGS} ${EXTRA_INCLUDE_FLAGS}" \
        -DCMAKE_C_LINK_FLAGS="${LINK_FLAGS}" \
        -DCMAKE_CXX_LINK_FLAGS="${LINK_FLAGS}" \
        -DCF_DEPLOYMENT_SWIFT=ON \
        -DCMAKE_Swift_COMPILER=${SWIFT_NATIVE_PATH}/swiftc \
        -DCMAKE_Swift_FLAGS="${SWIFTC_FLAGS}" \
        -DCMAKE_Swift_FLAGS_DEBUG="" \
        -DCMAKE_Swift_FLAGS_RELEASE="" \
        -DCMAKE_Swift_FLAGS_RELWITHDEBINFO="" \
        -DSwiftTesting_MACRO="${SWIFT_NATIVE_PATH}/../lib/swift/host/plugins/libTestingMacros.so" \

echo "Build swift-testing"
(cd $SWIFT_TESTING_BUILDDIR && ninja)

echo "Install swift-testing"
(cd $SWIFT_TESTING_BUILDDIR && ninja install)

echo "Fix-up archs"
find ${SWIFT_TESTING_INSTALL_PREFIX}/lib/swift/linux -name "x86_64*.swiftmodule" -execdir mv {} armv7-unknown-linux-gnueabihf.swiftmodule \;
find ${SWIFT_TESTING_INSTALL_PREFIX}/lib/swift/linux -name "x86_64*.swiftdoc" -execdir mv {} armv7-unknown-linux-gnueabihf.swiftdoc \;

echo "Install swift-testing to sysroot"
cp -rf ${SWIFT_TESTING_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/
