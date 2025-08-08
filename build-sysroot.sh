#!/bin/bash

set -e

SRC_ROOT=$(pwd)

DISTRIBUTION_NAME=$1
DISTRIUBTION_VERSION=$2
SYSROOT=$3

if [ -z $SYSROOT ]; then
    SYSROOT=sysroot-$DISTRIBUTION_NAME-$DISTRIUBTION_VERSION
fi
SYSROOT=$(pwd)/$SYSROOT

DISTRIBUTION="$DISTRIBUTION_NAME:$DISTRIUBTION_VERSION"

case $DISTRIUBTION_VERSION in
    "focal")
        INSTALL_GCC_VERSION=9
        ;;
    "bullseye")
        RASPIOS_VERSION="2025-05-06"
        RASPIOS_URL=https://downloads.raspberrypi.com/raspios_oldstable_lite_armhf/images/raspios_oldstable_lite_armhf-2025-05-07
        INSTALL_GCC_VERSION=10
        ;;
    "jammy" | "bookworm")
        RASPIOS_VERSION="2025-05-13"
        RASPIOS_URL=https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-$RASPIOS_VERSION
        INSTALL_GCC_VERSION=12
        ;;
    "mantic" | "noble")
        INSTALL_GCC_VERSION=13
        ;;
    "trixie")
        INSTALL_GCC_VERSION=14
        ;;
    *)
        echo "Unsupported distribution $DISTRIBUTION!"
        echo "If you'd like to support it, update this script to add the apt package list for it."
        exit
        ;;
esac

INSTALL_DEPS_CMD=" \
    apt-get update && \
    apt-get install -y \
        libc6-dev \
        libgcc-$INSTALL_GCC_VERSION-dev \
        libicu-dev \
        libstdc++-$INSTALL_GCC_VERSION-dev \
        libstdc++6 \
        linux-libc-dev \
        zlib1g-dev \
        libcurl4-openssl-dev \
        libxml2-dev \
        libsystemd-dev \
"

if [[ $DISTRIBUTION_NAME = "raspios" ]]; then
    INSTALL_DEPS_CMD="$INSTALL_DEPS_CMD symlinks"
fi

if [ ! -z $EXTRA_PACKAGES ]; then
    echo "Including extra packages: $EXTRA_PACKAGES"
    INSTALL_DEPS_CMD="$INSTALL_DEPS_CMD && apt-get install -y $EXTRA_PACKAGES"
fi

# This is for supporting armv6
if [[ $DISTRIBUTION_NAME = "raspios" ]]; then
    echo "Installing host dependencies..."
    sudo apt update && sudo apt install qemu-user-static p7zip xz-utils

    mkdir artifacts && true
    cd artifacts

    echo "Downloading raspios $RASPIOS_VERSION for $DISTRIUBTION_VERSION..."
    IMAGE_FILE=$RASPIOS_VERSION-raspios-$DISTRIUBTION_VERSION-armhf-lite.img
    DOWNLOAD_URL=$RASPIOS_URL/$IMAGE_FILE.xz
    wget -q -N $DOWNLOAD_URL

    if [ ! -f $IMAGE_FILE ]; then
        echo "Uncompressing $IMAGE_FILE.gz and extracting contents..."
        xz -dk $IMAGE_FILE.xz && true
    fi
    7z e -y $IMAGE_FILE

    echo "Mounting 1.img and needed passthroughs..."
    sudo umount -R sysroot && true
    rm -rf sysroot && mkdir sysroot
    sudo mount -o loop 1.img sysroot
    sudo mount --bind /dev sysroot/dev
    sudo mount --bind /dev/pts sysroot/dev/pts
    sudo mount --bind /proc sysroot/proc
    sudo mount --bind /sys sysroot/sys

    echo "Starting chroot to update dependencies & fix symlinks..."
    REMOVE_DEPS_CMD="apt-get remove -y --purge \
        apparmor \
        bluez \
        network-manager \
        linux-image* \
        *firmware* \
        openssh* \
        p7zip* \
        perl \
        perl-modules* \
        raspi* \
        rpi* \
        libqt5core5a \
    "
    sudo cp /usr/bin/qemu-arm-static sysroot/usr/bin
    sudo chroot sysroot qemu-arm-static /bin/bash -c "$REMOVE_DEPS_CMD && $INSTALL_DEPS_CMD && apt-get autoremove -y"
    sudo chroot sysroot qemu-arm-static /bin/bash -c "apt list --installed && symlinks -cr /usr/include && symlinks -cr /usr/lib"

    echo "Copying files from sysroot to $SYSROOT..."
    rm -rf $SYSROOT
    mkdir -p $SYSROOT/usr/lib
    cp -r sysroot/lib $SYSROOT/lib
    cp -r sysroot/usr/include $SYSROOT/usr/include
    cp -r sysroot/usr/lib/ld-linux-armhf.so.3 $SYSROOT/usr/lib/
    cp -r sysroot/usr/lib/os-release $SYSROOT/usr/lib/
    cp -r sysroot/usr/lib/arm-linux-gnueabihf $SYSROOT/usr/lib/
    cp -r sysroot/usr/lib/linux $SYSROOT/usr/lib/ && true
    cp -r sysroot/usr/lib/gcc $SYSROOT/usr/lib/

    # Cleanup
    rm -rf $SYSROOT/usr/include/aarch64-linux-gnu
    rm -rf $SYSROOT/usr/lib/gcc/arm-linux-gnueabihf/7
    rm -rf $SYSROOT/usr/lib/gcc/arm-linux-gnueabihf/7.5.0
    rm -rf $SYSROOT/usr/lib/gcc/arm-linux-gnueabihf/8

    echo "Umounting and cleaning up..."
    sudo umount -R sysroot
    rm -f *.fat
    rm -f *.img
else
    echo "Starting up qemu emulation"
    docker run --privileged --rm tonistiigi/binfmt --install all

    CONTAINER_NAME=swift-armhf-sysroot

    echo "Building $DISTRIBUTION distribution for sysroot"
    docker rm --force $CONTAINER_NAME
    docker run \
        --platform linux/armhf \
        --name $CONTAINER_NAME \
        $DISTRIBUTION \
        /bin/bash -c "$INSTALL_DEPS_CMD"

    echo "Extracting sysroot folders to $SYSROOT"
    rm -rf $SYSROOT
    mkdir -p $SYSROOT/usr
    docker cp $CONTAINER_NAME:/lib $SYSROOT/lib
    docker cp $CONTAINER_NAME:/usr/include $SYSROOT/usr/include
    docker cp $CONTAINER_NAME:/usr/lib $SYSROOT/usr/lib

    # Find broken links, re-copy
    cd $SYSROOT
    BROKEN_LINKS=$(find . -xtype l)
    while IFS= read -r link; do
        # Ignore empty links
        if [ -z "${link}" ]; then continue; fi

        echo "Replacing broken symlink: $link"
        link=$(echo $link | sed '0,/./ s/.//')
        docker cp -L $CONTAINER_NAME:$link $(dirname .$link)
    done <<< "$BROKEN_LINKS"

    echo "Cleaning up"
    docker rm $CONTAINER_NAME
fi
