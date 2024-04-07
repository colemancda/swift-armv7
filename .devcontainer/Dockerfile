FROM swift:5.10-jammy

# Install zsh
ARG INSTALL_ZSH="true"

# Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"

# Install needed packages and setup non-root user.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/common-debian.sh /tmp/library-scripts/
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/library-scripts

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
     ninja-build \
     gnupg \
     gnupg2 \
     libc6-dev \
     libcurl4-openssl-dev \
     libedit2 \
     libgcc-11-dev \
     libpython3-dev \
     python3-lldb-13 \
     libsqlite3-0 \
     libstdc++-11-dev \
     libxml2-dev \
     libz3-dev \
     pkg-config \
     tzdata \
     zlib1g-dev \
     && rm -r /var/lib/apt/lists/*
