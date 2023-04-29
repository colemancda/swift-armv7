FROM swift:5.8-jammy

# Install needed packages and setup non-root user.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY .devcontainer/library-scripts/common-debian.sh /tmp/library-scripts/
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/library-scripts

# Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="lts/*"
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \
    PATH=${NVM_DIR}/current/bin:${PATH}
COPY .devcontainer/library-scripts/node-debian.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}" \
    && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# Install dependencies
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt-get -q update && \
    apt-get -q install -y \
    wget \
    curl \
    build-essential \
    bash \
    bc \
    binutils \
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
    python3 \
    rsync \
    sed \
    tar \
    unzip \
    cmake \
    gnupg \
    gnupg2 \
    libc6-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libgcc-9-dev \
    libpython3.8 \
    libsqlite3-0 \
    libstdc++-9-dev \
    libxml2-dev \
    libz3-dev \
    pkg-config \
    tzdata \
    zlib1g-dev \
    && rm -r /var/lib/apt/lists/*

# Copy scripts
COPY . /usr/src/swift-armv7

# Set environment
ENV SRC_ROOT=/usr/src/swift-armv7

# Generate destination.json
RUN cd $SRC_ROOT && \
    $SRC_ROOT/generate-swiftpm-toolchain.sh

# Fetch Debian 11 armhf sysroot and Swift runtime
RUN cd $SRC_ROOT && \
    export DOWNLOAD_SWIFT_RUNTIME=1 && \
    $SRC_ROOT/fetch-binaries.sh && \
    rm -rf $SRC_ROOT/build/swift-armv7.tar.gz
