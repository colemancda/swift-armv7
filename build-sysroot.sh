#!/bin/bash

set -e

SRC_ROOT=$(pwd)

CONTAINER_NAME=swift-armv7-sysroot
DISTRIUBTION=$1
SYSROOT=$2

if [ -z $SYSROOT ]; then
    SYSROOT=sysroot-$(echo "$DISTRIUBTION" | tr : -)
fi

case $DISTRIUBTION in
    ubuntu:focal)
        INSTALL_DEPS_CMD=" \
            apt-get update && \
            apt-get install -y \
                libc6-dev \
                libgcc-9-dev \
                libicu-dev \
                libstdc++-9-dev \
                libstdc++6 \
                linux-libc-dev \
                zlib1g-dev \
                libcurl4-openssl-dev \
                libxml2-dev \
                libsystemd-dev \
        "
        ;;
    "debian:bullseye")
        INSTALL_DEPS_CMD=" \
            apt-get update && \
            apt-get install -y \
                libc6-dev \
                libgcc-10-dev \
                libicu-dev \
                libstdc++-10-dev \
                libstdc++6 \
                linux-libc-dev \
                zlib1g-dev \
                libcurl4-openssl-dev \
                libxml2-dev \
                libsystemd-dev \
        "
        ;;
    "ubuntu:jammy" | "debian:bookworm")
        INSTALL_DEPS_CMD=" \
            apt-get update && \
            apt-get install -y \
                libc6-dev \
                libgcc-12-dev \
                libicu-dev \
                libstdc++-12-dev \
                libstdc++6 \
                linux-libc-dev \
                zlib1g-dev \
                libcurl4-openssl-dev \
                libxml2-dev \
                libsystemd-dev \
        "
        ;;
    "ubuntu:mantic" | "ubuntu:noble")
        INSTALL_DEPS_CMD=" \
            apt-get update && \
            apt-get install -y \
                libc6-dev \
                libgcc-13-dev \
                libicu-dev \
                libstdc++-13-dev \
                libstdc++6 \
                linux-libc-dev \
                zlib1g-dev \
                libcurl4-openssl-dev \
                libxml2-dev \
                libsystemd-dev \
        "
        ;;
    *)
        echo "Unsupported distribution $DISTRIBUTION!"
        echo "If you'd like to support it, update this script to add the apt package list for it."
        exit
        ;;
esac

if [ ! -z $EXTRA_PACKAGES ]; then
    echo "Including extra packages: $EXTRA_PACKAGES"
    INSTALL_DEPS_CMD="$INSTALL_DEPS_CMD && apt-get install -y $EXTRA_PACKAGES"
fi

echo "Starting up qemu emulation"
docker run --privileged --rm tonistiigi/binfmt --install all

echo "Building $DISTRIUBTION distribution for sysroot"
docker rm --force $CONTAINER_NAME
docker run \
    --platform linux/arm/v7 \
    --name $CONTAINER_NAME \
    $DISTRIUBTION \
    /bin/bash -c "$INSTALL_DEPS_CMD"

echo "Extracting sysroot folders to $SYSROOT"
rm -rf $SYSROOT
mkdir -p $SYSROOT/usr
docker cp $CONTAINER_NAME:/lib $SYSROOT/lib
docker cp $CONTAINER_NAME:/usr/lib $SYSROOT/usr/lib
docker cp $CONTAINER_NAME:/usr/include $SYSROOT/usr/include

# Find broken links, re-copy
cd $SYSROOT
BROKEN_LINKS=$(find . -xtype l)
while IFS= read -r link; do
    echo "Replacing broken symlink: $link"
    link=$(echo $link | sed '0,/./ s/.//')
    docker cp -L $CONTAINER_NAME:$link $(dirname .$link)
done <<< "$BROKEN_LINKS"

echo "Cleaning up"
docker rm $CONTAINER_NAME
