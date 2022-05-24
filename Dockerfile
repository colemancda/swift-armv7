FROM swift:5.5.3-focal

# Install dependencies
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    llvm-12-dev \
    ninja-build \
    proot \
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
    && rm -r /var/lib/apt/lists/*

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

# Build Swift
# RUN ./build.sh && rm -rf ./build && rm -rf ./downloads