# swift-armv7
Swift runtime for Linux Armv7

## Compilation

Set the required environment variables for the scripts:

```
export SWIFT_NATIVE_PATH="/usr/bin" # Only needed on Linux
./build.sh
```

`SWIFT_PACKAGE_SRCDIR` can be set to the root of your own packages to cross compile them using `build-swift-package.sh`.
