FROM swift:5.7-jammy

# Install dependencies
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    ninja-build \
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
    && rm -r /var/lib/apt/lists/*

# Copy files
WORKDIR /usr/src/swift-armv7
COPY . .

# Set environment
ENV SRC_ROOT=/usr/src/swift-armv7
ENV STAGING_DIR=/usr/src/swift-armv7/bullseye-armv7

# Build Swift
# RUN ./build.sh && rm -rf ./build && rm -rf ./downloads