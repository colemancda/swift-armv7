#!/bin/bash
set -e
source swift-define

if [ $STATIC_SWIFT_STDLIB ]; then
    PARAMS="--static-swift-stdlib"
    STATIC_SUFFIX="-static"
    STATIC="Static"
else
    # Only build tests when not building statically
    PARAMS="--build-tests"
fi

echo "Cross compile Swift package $PARAMS"
rm -rf $SWIFT_PACKAGE_BUILDDIR
mkdir -p $SWIFT_PACKAGE_BUILDDIR
cd $SWIFT_PACKAGE_SRCDIR
$SWIFT_NATIVE_PATH/swift build \
    --configuration ${SWIFTPM_CONFIGURATION} \
    --scratch-path ${SWIFT_PACKAGE_BUILDDIR}${STATIC_SUFFIX} \
    --destination ${SWIFTPM_DESTINATION_FILE} \
    $PARAMS
