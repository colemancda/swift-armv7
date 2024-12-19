FROM ubuntu:22.04

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt-get -y update &&    \
    apt-get -y install      \
    build-essential         \
    cmake                   \
    file                    \
    git                     \
    icu-devtools            \
    libcurl4-openssl-dev    \
    libedit-dev             \
    libicu-dev              \
    libncurses5-dev         \
    libpython3-dev          \
    libsqlite3-dev          \
    libxml2-dev             \
    ninja-build             \
    pkg-config              \
    python2                 \
    python-six              \
    python2-dev             \
    python3-six             \
    python3-distutils       \
    python3-pkg-resources   \
    python3-psutil          \
    rsync                   \
    swig                    \
    systemtap-sdt-dev       \
    tzdata                  \
    uuid-dev                \
    zip                     \
    wget                    \
    && rm -r /var/lib/apt/lists/*

# Get latest cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - > /etc/apt/trusted.gpg.d/kitware.gpg && \
    echo 'deb [signed-by=/etc/apt/trusted.gpg.d/kitware.gpg] https://apt.kitware.com/ubuntu/ jammy main' > /etc/apt/sources.list.d/kitware.list && \
    apt-get -y update && apt-get -y install cmake

# Everything up to here should cache nicely between Swift versions, assuming dev dependencies change little
ARG SWIFT_PLATFORM=ubuntu22.04
ARG SWIFT_BRANCH=development
ARG SWIFT_VERSION=swift-DEVELOPMENT-SNAPSHOT-2024-12-13-a
ARG SWIFT_WEBROOT=https://download.swift.org

ENV SWIFT_SIGNING_KEY=$SWIFT_SIGNING_KEY \
    SWIFT_PLATFORM=$SWIFT_PLATFORM \
    SWIFT_BRANCH=$SWIFT_BRANCH \
    SWIFT_VERSION=$SWIFT_VERSION \
    SWIFT_WEBROOT=$SWIFT_WEBROOT

RUN set -e; \
    ARCH_NAME="$(dpkg --print-architecture)"; \
    url=; \
    case "${ARCH_NAME##*-}" in \
        'amd64') \
            OS_ARCH_SUFFIX=''; \
            ;; \
        'arm64') \
            OS_ARCH_SUFFIX='-aarch64'; \
            ;; \
        *) echo >&2 "error: unsupported architecture: '$ARCH_NAME'"; exit 1 ;; \
    esac; \
    SWIFT_WEBDIR="$SWIFT_WEBROOT/$SWIFT_BRANCH/$(echo $SWIFT_PLATFORM | tr -d .)$OS_ARCH_SUFFIX" \
    && SWIFT_BIN_URL="$SWIFT_WEBDIR/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM$OS_ARCH_SUFFIX.tar.gz" \
    && echo $SWIFT_BIN_URL \
    # - Grab curl here so we cache better up above
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -q update && apt-get -q install -y curl && rm -rf /var/lib/apt/lists/* \
    # - Download the GPG keys, Swift toolchain, and toolchain signature, and verify.
    && curl -fsSL "$SWIFT_BIN_URL" -o swift.tar.gz \
    # - Unpack the toolchain, set libs permissions, and clean up.
    && tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && chmod -R o+r /usr/lib/swift \
    && apt-get purge --auto-remove -y curl

# Print Installed Swift Version
RUN swift --version

# Add user for building, customizable
ARG USER=build-user
ARG UID=1000
RUN useradd -m -r -u ${UID} ${USER}
