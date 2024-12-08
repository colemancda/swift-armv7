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
        "
        ;;
    debian:bullseye)
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
        "
        ;;
    *)
        echo "Unsupported distribution $DISTRIBUTION!"
        echo "If you'd like to support it, update this script to add the apt package list for it."
        ;;
esac

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

echo "Cleaning up"
docker rm $CONTAINER_NAME
