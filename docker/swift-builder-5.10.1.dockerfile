FROM swift:5.10.1-jammy

RUN apt-get -y update &&    \
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
    wget

ARG USER=builduser
ARG UID=1000
RUN useradd ${USER} -u ${UID}
