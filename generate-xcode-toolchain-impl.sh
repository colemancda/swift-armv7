#!/bin/bash
##===----------------------------------------------------------------------===##
##
## This source file is part of the Swift open source project
##
## Copyright (c) 2014-2022 Apple Inc. and the Swift project authors
## Licensed under Apache License v2.0 with Runtime Library Exception
##
## See http://swift.org/LICENSE.txt for license information
## See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
##
##===----------------------------------------------------------------------===##

set -eu

source swift-define

export PATH="/bin:/usr/bin:$(brew --prefix)/bin"
VERSION=${VERSION:-5.8-RELEASE}
if [[ -z "${VERSION##*RELEASE*}" ]]; then
  branch=swift-${VERSION%%RELEASE}release
elif [[ -z "${VERSION##DEVELOPMENT-SNAPSHOT*}" ]]; then
  branch=development
else
  branch=swift-${VERSION%%DEV*}branch
fi

function usage() {
    echo >&2 "Usage: $0 TMP-DIR SWIFT-FOR-MACOS.pkg SWIFT-FOR-LINUX.tar.gz"
    echo >&2
    echo >&2 "Example: $0 /tmp/ ~/Downloads/swift-${VERSION}-osx.pkg ~/Downloads/swift-${VERSION}-armhf-debian11.04.tar.gz"
    echo >&2
    echo >&2 "Complete example:"
    echo >&2 "  # Download the Swift binaries for Debian and macOS"
    echo >&2 "  curl -o ~/Downloads/swift-${VERSION}-armhf-debian11.04.tar.gz https://github.com/colemancda/swift-armv7/releases/download/0.5.1/swift-armv7.tar.gz"
    echo >&2 "  curl -o ~/Downloads/swift-${VERSION}-osx.pkg https://swift.org/builds/${branch}/xcode/swift-${VERSION}/swift-${VERSION}-osx.pkg"
    echo >&2 "  # Build the SDK and toolchain from that"
    echo >&2 "  $0 /tmp/ ~/Downloads/swift-${VERSION}-osx.pkg ~/Downloads/swift-${VERSION}-armhf-debian11.04.tar.gz"
}

if [[ $# -ne 3 ]]; then
    usage
    exit 1
fi

function realpath() {
    if [[ "${1:0:1}" = / ]]; then
        echo "$1"
    else
        (
        cd "$(dirname "$1")"
        echo "$(pwd)/$(basename "$1")"
        )
    fi
}

function fix_glibc_modulemap() {
    local glc_mm
    local tmp
    local inc_dir

    glc_mm="$1"
    echo "glibc.modulemap at '$glc_mm'"
    test -f "$glc_mm"

    tmp=$(mktemp "$glc_mm"_orig_XXXXXX)
    inc_dir="$(dirname "$glc_mm")/private_includes"
    cat "$glc_mm" >> "$tmp"
    echo "Paths:"
    echo " - original glibc.modulemap: $tmp"
    echo " - new      glibc.modulemap: $glc_mm"
    echo " - private includes dir    : $inc_dir"
    echo -n > "$glc_mm"
    rm -rf "$inc_dir"
    mkdir "$inc_dir"
    cat "$tmp" | while IFS='' read line; do
        if [[ "$line" =~ ^(\ *header\ )\"\/+usr\/include\/(arm-linux-gnueabihf\/)?([^\"]+)\" ]]; then
            local orig_inc
            local rel_repl_inc
            local repl_inc

            orig_inc="${BASH_REMATCH[3]}"
            rel_repl_inc="$(echo "$orig_inc" | tr / _)"
            repl_inc="$inc_dir/$rel_repl_inc"
            echo "${BASH_REMATCH[1]} \"$(basename "$inc_dir")/$rel_repl_inc\"" >> "$glc_mm"
            if [[ "$orig_inc" == "uuid/uuid.h" ]]; then
                # no idea why ;)
                echo "#include <linux/uuid.h>" >> "$repl_inc"
            else
                echo "#include <$orig_inc>" >> "$repl_inc"
            fi
            true
        else
            echo "$line" >> "$glc_mm"
        fi
    done
}

# set -xv
# where to get stuff from
dest=$(realpath "$1")
macos_swift_pkg=$(realpath "$2")
linux_swift_pkg=$(realpath "$3")
test -f "$macos_swift_pkg"
test -f "$linux_swift_pkg"

# config
blocks_h_url="https://raw.githubusercontent.com/apple/swift-corelibs-libdispatch/main/src/BlocksRuntime/Block.h"
xc_tc_name="swift-armv7.xctoolchain"
linux_sdk_name="debian-bullseye.sdk"
cross_tc_basename="cross-toolchain"
clang_package_url="https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/clang+llvm-13.0.1-x86_64-apple-darwin.tar.xz"
debian_mirror="http://ftp.us.debian.org/debian"
packages_file="$debian_mirror/dists/bullseye/main/binary-armhf/Packages.gz"
pkg_names=( libc6-dev libcurl4 libedit2 libgcc-9-dev libpython3.9 libsqlite3-0 libstdc++-9-dev libxml2 libz3-dev pkg-config tzdata uuid-dev zlib1g-dev python3.9 uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython3.9-dev libncurses5-dev pkg-config libblocksruntime-dev libcurl4-openssl-dev systemtap-sdt-dev )
pkgs=()

# url
function download_stdout() {
    curl --fail -s "$1"
}

# url, key
function download_with_cache() {
    mkdir -p "$dest/cache"
    local out
    out="$dest/cache/$2"
    if [[ ! -f "$out" ]]; then
        # Download with curl, also follow redirects.
        curl -L --fail -s -o "$out" "$1"
    fi
    echo "$out"
}

# dst, file
function unpack_deb() {
    local tmp
    tmp=$(mktemp -d /tmp/.unpack_deb_XXXXXX)
    (
    cd "$tmp"
    ar -x "$2"
    tar -C "$1" -xf data.tar.*
    )
    rm -rf "$tmp"
}

# dst, file
function unpack_pkg() {
    local tmp
    tmp=$(mktemp -d /tmp/.unpack_pkg_XXXXXX)
    (
    cd "$tmp"
    xar -xf "$2"
    )
    (
    cd "$1"
    cat "$tmp"/*.pkg/Payload | gunzip -dc | cpio -i
    )
    rm -rf "$tmp"
}

# dst, file
function unpack() {
    ext=${2##*.}
    "unpack_$ext" "$@"
}

cd "$dest"

rm -rf $cross_tc_basename
mkdir -p "$cross_tc_basename/$linux_sdk_name"

# oopsie, this is slow but seemingly fast enough :)
while read -r line; do
    for pkg_name in "${pkg_names[@]}"; do
        if [[ "$line" =~ ^Filename:\ (.*\/([^/_]+)_.*$) ]]; then
            # echo "${BASH_REMATCH[2]}"
            if [[ "${BASH_REMATCH[2]}" == "$pkg_name" ]]; then
                new_pkg="$debian_mirror/${BASH_REMATCH[1]}"
                pkgs+=( "$new_pkg" )
                echo "- will download $new_pkg"
            fi
        fi
    done
done < <(download_stdout "$packages_file" | gunzip -d -c | grep ^Filename:)

tmp=$(mktemp -d "$dest/tmp_pkgs_XXXXXX")
(
cd "$tmp"
for f in "${pkgs[@]}"; do
    name="$(basename "$f")"
    archive="$(download_with_cache "$f" "$name")"
    unpack "$dest/$cross_tc_basename/$linux_sdk_name" "$archive"
done
)
rm -rf "$tmp"
(
cd $cross_tc_basename
mkdir -p "$xc_tc_name/usr/bin"

clang_txz="$(download_with_cache "$clang_package_url" clang.tar.xz)"
tmp=$(mktemp -d "$dest/tmp_pkgs_XXXXXX")
(
cd "$tmp"
tar --strip-components=1 -zxf "$clang_txz"
)
cp "$tmp/bin/lld" "$xc_tc_name/usr/bin/ld.lld"
rm -rf "$tmp"

# fix absolute symlinks
find "$linux_sdk_name" -type l | while read -r line; do
    dst=$(readlink "$line")
    if [[ "${dst:0:1}" = / ]]; then
        rm "$line"
        fixedlink=$(echo "./$(dirname "${line#${linux_sdk_name}/}")" | sed 's:/[^/]*:/..:g')"${dst}"
        echo ln -s "${fixedlink#./}" "${line#./}"
        ln -s "${fixedlink#./}" "${line#./}"
    fi
done
ln -s 5 "$linux_sdk_name/usr/lib/gcc/arm-linux-gnueabihf/9"

tmp=$(mktemp -d "$dest/tmp_pkgs_XXXXXX")
unpack "$tmp" "$macos_swift_pkg"
rsync -a "$tmp/" "$xc_tc_name"
rm -rf "$tmp"

tmp=$(mktemp -d "$dest/tmp_pkgs_XXXXXX")
tar -C "$tmp" --strip-components 1 -xf "$linux_swift_pkg"
rsync -a "$tmp/usr/lib/swift/linux" "$xc_tc_name/usr/lib/swift/"
rsync -a "$tmp/usr/lib/swift_static/linux" "$xc_tc_name/usr/lib/swift_static/"
rsync -a "$tmp/usr/lib/swift/dispatch" "$linux_sdk_name/usr/include/"
rsync -a "$tmp/usr/lib/swift/os" "$linux_sdk_name/usr/include/"
rsync -a "$tmp/usr/lib/swift/CoreFoundation" "$linux_sdk_name/usr/include/"
rm -rf "$tmp"
curl --fail -s -o "$linux_sdk_name/usr/include/Block.h" "$blocks_h_url"
if [ ! -e "$xc_tc_name/usr/bin/swift-autolink-extract" ]; then
    ln -s swift "$xc_tc_name/usr/bin/swift-autolink-extract"
fi
)

# fix up glibc modulemap
fix_glibc_modulemap "$cross_tc_basename/$xc_tc_name/usr/lib/swift/linux/$SWIFT_TARGET_ARCH/glibc.modulemap"

echo
echo "OK, your cross compilation toolchain for Debian 11 armhf is now ready to be used"
echo " - SDK: $(pwd)/$cross_tc_basename/$linux_sdk_name"
echo " - toolchain: $(pwd)/$cross_tc_basename/$xc_tc_name"
