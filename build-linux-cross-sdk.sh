#!/bin/bash

set -e

SRC_ROOT=$(pwd)
ARTIFACTS_DIR=$SRC_ROOT/artifacts
TARGET_TRIPLE=armv7-unknown-linux-gnueabihf
TARGET_ARCH=armv7

function print_usage() {
    echo "$0 <swift-tag> <distribution>"
    exit 1
}

SWIFT_TAG=$1
if [ -z $SWIFT_TAG ]; then
    echo "The Swift version tag must be provided. This is needed to be able to identify the SDK once"
    echo "it is generated. The version should match one of the official release tags versions from"
    echo "https://www.swift.org/download/#releases and look like this: swift-5.10.1-RELEASE"
    print_usage
    exit 1
fi

DISTRIBUTION=$2
if [ -z $DISTRIBUTION ]; then
    echo "Distribution name must be provided. This is needed to be able to identify the cross-compilation"
    echo "toolchain for the target. The sysroot should be generated using the ./build-sysroot.sh script."
    print_usage
    exit 1
fi
SYSROOT=${SYSROOT:=$SRC_ROOT/sysroot-$DISTRIBUTION}

# Create SDK directory
SDK_NAME=${SWIFT_TAG}-${DISTRIBUTION}-${TARGET_ARCH}
SDK_DIR=$ARTIFACTS_DIR/$SDK_NAME
mkdir -p $SDK_DIR

# Install directories
INSTALL_DESTDIR=${INSTALL_DESTDIR:=$SRC_ROOT/build/swift-install}
INSTALLABLE_SDK_PACKAGE=${INSTALLABLE_SDK_PACKAGE:=$ARTIFACTS_DIR/$SDK_NAME.tar.gz}

# Copy sysroot into target SDK dir
echo "Copying $DISTRIBUTION sysroot into $SDK_DIR..."
TARGET_SDK_DIR=$SDK_DIR/$DISTRIBUTION
mkdir -p $TARGET_SDK_DIR
cp -rf $SYSROOT/* $TARGET_SDK_DIR

# Copy swift build into target SDK dir
echo "Copying Swift install into $TARGET_SDK_DIR..."
cp -rf $INSTALL_DESTDIR/* $TARGET_SDK_DIR

# Annoying but helpful for Swift versions < 6.1
echo "Creating SDKSettings.json to silence cross-compilation warnings"
cat <<EOT > $TARGET_SDK_DIR/SDKSettings.json
{
  "SupportedTargets": {},
  "Version": "0.0.1",
  "CanonicalName": "linux"
}
EOT

# Create destination.json file
echo "Creating destination.json file for SDK..."
SDK_INSTALL_DIR="/opt/$SDK_NAME/$DISTRIBUTION"
cat <<EOT > $SDK_DIR/$DISTRIBUTION.json
{
    "version":1,
    "sdk":"$SDK_INSTALL_DIR",
    "toolchain-bin-dir":"/usr/bin",
    "target":"$TARGET_TRIPLE",
    "dynamic-library-extension":"so",
    "extra-cc-flags":[
       "-fPIC"
    ],
    "extra-swiftc-flags":[
       "-target", "$TARGET_TRIPLE",
       "-use-ld=lld",
       "-Xlinker", "-rpath", "-Xlinker", "/usr/lib/swift/linux",
       "-Xlinker", "-rpath", "-Xlinker", "/usr/lib/swift/linux/armv7",
       "-resource-dir", "$SDK_INSTALL_DIR/usr/lib/swift",
       "-sdk", "$SDK_INSTALL_DIR",
       "-Xcc", "--gcc-toolchain=$SDK_INSTALL_DIR/usr"
    ],
    "extra-cpp-flags":[
    ]
}
EOT

# Create README.md with instructions on usage
echo "Creating README.md with instructions for usage..."
cat << EOT > $SDK_DIR/README.md
# Cross-Compilation SDK: $SDK_NAME

This is an old-style Swift cross-compilation SDK that provides the needed sysroot and Swift libraries
to compile for the given distribution and architecture. These SDKs require that they be installed at
an absolute path for them to work. This SDK is built to be installed at /opt like this:

 - /opt/$SDK_NAME

If you desire to install it to a different location, simply edit the $DISTRIBUTION.json file in this
directory to change all the "/opt" paths to your new location.

The SDK also assumes that your host Swift toolchain is installed at /usr/bin, but this can also be
changed in the $DISTRIBUTION.json file. PLEASE NOTE: You *MUST* use the exact same version of the
host Swift toolchain ($SWIFT_TAG) for this SDK to work. If you have a version mismatch you will be
unable to cross-compile using this SDK. You have been warned!

To use the SDK, simply provide the "--destination" param on the command line when building a Swift
app:

> swift build --destination /opt/$SDK_NAME/$DISTRIBUTION.json

Of course, if you have installed the SDK to a different path, use that path instead.
EOT

# Compress installable SDK for distribution
echo "Compressing installable SDK package for distribution..."
cd $ARTIFACTS_DIR
tar -czf $INSTALLABLE_SDK_PACKAGE $SDK_NAME
