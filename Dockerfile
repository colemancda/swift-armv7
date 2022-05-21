FROM swift:5.6.1-focal

# Install dependencies
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    llvm-12-dev \
    ninja-build \
    qemu-user-static \
    debootstrap \
    wget \
    build-essential \
    bash \
    bc \
    binutils \
    build-essential \
    bzip2 \
    cpio \
    g++ \
    gcc \
    git \
    gzip \
    libncurses5-dev \
    make \
    mercurial \
    whois \
    patch \
    perl \
    python \
    rsync \
    sed \
    tar \
    unzip \
    sudo \
    && rm -r /var/lib/apt/lists/*

WORKDIR /usr/src/buildroot-external

# Install latest Cmake
RUN set -e; \
    ARCH_NAME="$(dpkg --print-architecture)"; \
    case "${ARCH_NAME##*-}" in \
        'amd64') \
            OS_ARCH_SUFFIX='-x86_64'; \
            ;; \
        'arm64') \
            OS_ARCH_SUFFIX='-aarch64'; \
            ;; \
        *) echo >&2 "error: unsupported architecture: '$ARCH_NAME'"; exit 1 ;; \
    esac; \
    export CMAKE_VERSION="cmake-3.22.4-linux$OS_ARCH_SUFFIX"; \
    cd /tmp; \
    wget "https://github.com/Kitware/CMake/releases/download/v3.22.4/$CMAKE_VERSION.tar.gz"; \
    tar -xf $CMAKE_VERSION.tar.gz; \
    rm -rf $CMAKE_VERSION.tar.gz; \
    rm -rf $CMAKE_VERSION/man; \
    cp -rf $CMAKE_VERSION/* /usr/local/; \
    rm -rf $CMAKE_VERSION;

# Modify LLVM headers
RUN cp /usr/lib/llvm-12/include/llvm/Config/llvm-config.h /usr/lib/llvm-12/include/llvm/Config/config.h

# Copy files
WORKDIR /usr/src/swift-armv7
COPY . .

# Set environment
ENV SRC_ROOT=/usr/src/swift-armv7
ENV STAGING_DIR=/usr/src/swift-armv7/bullseye-armv7

# Build target environment
RUN set -e; \
    export STAGING_DIR=/usr/src/swift-armv7/bullseye-armv7; \
    mkdir -p $STAGING_DIR; \
    sudo debootstrap --foreign --arch armhf bullseye $STAGING_DIR http://ftp.us.debian.org/debian; \
    cp /usr/bin/qemu-arm-static $STAGING_DIR/usr/bin/;

RUN set -e; \
    export STAGING_DIR=/usr/src/swift-armv7/bullseye-armv7; \
    chroot $STAGING_DIR /usr/bin/qemu-arm-static /debootstrap/debootstrap --second-stage \
    chroot $STAGING_DIR /usr/bin/qemu-arm-static /usr/bin/bash apt update; \
    chroot $STAGING_DIR /usr/bin/qemu-arm-static /usr/bin/bash apt install gcc libstdc++-10-dev libgcc-10-dev libxml2-dev libcurl4-openssl-dev;
