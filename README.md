# swift-armv7
Swift runtime for Linux Armv7

## Compilation

Set the required environment variables for the scripts:

```
export STAGING_DIR="${STAGING_DIR:=$SRC_ROOT/bullseye-armv7}"
export SWIFT_NATIVE_PATH="${SWIFT_NATIVE_PATH:=/usr/bin}"
```

Make sure the Debian Bullseye armhf sysroot is at `STAGING_DIR` and `SWIFT_NATIVE_PATH` points to your Swift compiler installation.
`SWIFT_PACKAGE_SRCDIR` can be set to the root of your own packages to cross compile them using `build-swift-package.sh`.
