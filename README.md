# swift-armv7
Swift runtime for Linux Armv7

## Compilation

Set the required environment variables for the scripts:

### Build Swift runtime cross compileed from Linux
```
export SWIFT_NATIVE_PATH="/usr/bin"
./build.sh
```

### Cross compile Swift package from Linux
```
export SWIFT_NATIVE_PATH="/usr/bin"
export SWIFT_PACKAGE_SRCDIR=/home/user/Developer/MySwiftPackage
./build.sh # Or skip if using cached build
./build-swift-package.sh
```

### Cross compile Swift package from macOS
```
export SWIFT_PACKAGE_SRCDIR=/home/user/Developer/MySwiftPackage
export SWIFT_NATIVE_PATH=/tmp/cross-toolchain/debian-bullseye.sdk
./generate-xcode-toolchain.sh
./build-swift-package.sh
```

`SWIFT_PACKAGE_SRCDIR` can be set to the root of your own packages to cross compile them using `build-swift-package.sh`.
