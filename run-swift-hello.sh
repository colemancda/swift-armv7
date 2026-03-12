#!/bin/bash

set -e
source swift-define

# Run swift-hello
./run-swift-package.sh swift-hello

# Run swift-hello package tests if they exist
SWIFT_PACKAGE_TESTS_BINARY=$SWIFT_PACKAGE_BUILDDIR/${SWIFTPM_CONFIGURATION}/swift-helloPackageTests.xctest
if [ -f $SWIFT_PACKAGE_TESTS_BINARY ]; then
    # Run the default xctests
    ./run-swift-package.sh swift-helloPackageTests.xctest

    # If we're on Swift 6.0 or later, also run the tests with the Swift Testing library
    if [[ $SWIFT_VERSION == *"swift-6."* ]] || [[ $SWIFT_VERSION == *"swift-DEVELOPMENT"* ]]; then
        ./run-swift-package.sh swift-helloPackageTests.xctest --testing-library swift-testing
    fi
fi
