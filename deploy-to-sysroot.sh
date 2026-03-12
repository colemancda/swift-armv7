#!/bin/bash
set -e
source swift-define

echo "Install Dispatch to sysroot"
cp -rf ${LIBDISPATCH_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/

echo "Install Foundation to sysroot"
cp -rf ${FOUNDATION_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/

echo "Install XCTest to sysroot"
cp -rf ${XCTEST_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/

echo "Install Dispatch Static to sysroot"
cp -rf ${LIBDISPATCH_STATIC_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/

echo "Install Foundation Static to sysroot"
cp -rf ${FOUNDATION_STATIC_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/

if [ -d $SWIFT_TESTING_INSTALL_PREFIX ]; then
    echo "Install Testing to sysroot"
    cp -rf ${SWIFT_TESTING_INSTALL_PREFIX}/* ${STAGING_DIR}/usr/
fi
