#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q install -y \
    libc6-dev \
    libatomic1 \
    libcurl4 \
    libedit2 \
    libgcc-9-dev \
    libpython3.9 \
    libsqlite3-0 \
    libstdc++-9-dev \
    libxml2 \
    libz3-dev \
    pkg-config \
    tzdata \
    uuid-dev \
    zlib1g-dev \
    python3.9 \
    uuid-dev \
    libicu-dev \
    icu-devtools \
    libbsd-dev \
    libedit-dev \
    libxml2-dev \
    libsqlite3-dev \
    swig \
    libpython3.9-dev \
    libncurses5-dev \
    pkg-config \
    libblocksruntime-dev \
    libcurl4-openssl-dev \
    systemtap-sdt-dev \
    && rm -r /var/lib/apt/lists/*