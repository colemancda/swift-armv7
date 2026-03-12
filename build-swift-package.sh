#!/bin/bash
set -e
source swift-define

if [ $STATIC_SWIFT_STDLIB ]; then
    PARAMS="--static-swift-stdlib"
else
    # Only build tests when not building statically
    PARAMS="--build-tests"
fi

echo "Cross compile Swift package $PARAMS"
cd $SWIFT_PACKAGE_SRCDIR
$SWIFT_NATIVE_PATH/swift build \
    --configuration ${SWIFTPM_CONFIGURATION} \
    --scratch-path ${SWIFT_PACKAGE_BUILDDIR} \
    --destination ${SWIFTPM_DESTINATION_FILE} \
    $PARAMS
