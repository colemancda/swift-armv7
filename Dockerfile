FROM colemancda/swift-armv7

# Copy everything
COPY . .

# Copy Debian sysroot
#COPY ./bullseye-armv7 /workspaces/swift-armv7/bullseye-armv7

# Copy Swift runtime
#COPY ./build/swift-linux-armv7-install /workspaces/swift-armv7/build/swift-linux-armv7-install
