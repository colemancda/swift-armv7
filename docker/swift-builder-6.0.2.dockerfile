FROM swift:6.0.2-noble

RUN apt-get -y update &&    \
    apt-get -q install -y   \
    build-essential         \
    cmake                   \
    file                    \
    ninja-build             \
    binutils                \
    git                     \
    unzip                   \
    gnupg2                  \
    libc6-dev               \
    libcurl4-openssl-dev    \
    libedit2                \
    python3                 \
    libgcc-13-dev           \
    libpython3-dev          \
    libsqlite3-0            \
    libstdc++-13-dev        \
    libxml2-dev             \
    libncurses-dev          \
    libz3-dev               \
    pkg-config              \
    tzdata                  \
    zlib1g-dev              \
    wget

ARG USER
ARG UID
RUN if [ ! -z $USER ]; then useradd ${USER} -u ${UID}; fi
