# Configurable
source .config
source swift-define

set -e

# Build paths
LIBDISPATCH_SRCDIR=$SRC_ROOT/downloads/swift-corelibs-libdispatch-swift-${SWIFT_VERSION}-RELEASE
LIBDISPATCH_BUILDDIR=$SRC_ROOT/build/libdispatch-armv7
SWIFT_CMAKE_TOOLCHAIN_FILE=$SRC_ROOT/build/linux-$SWIFT_TARGET_ARCH-toolchain.cmake

echo "Dispatch build folder ${LIBDISPATCH_BUILDDIR}"
rm -rf $LIBDISPATCH_BUILDDIR
mkdir -p $LIBDISPATCH_BUILDDIR

echo "Configure Dispatch"
rm -rf $LIBDISPATCH_BUILDDIR/CMakeCache.txt
cmake -S $LIBDISPATCH_SRCDIR -B $LIBDISPATCH_BUILDDIR -G Ninja \
    -DCMAKE_INSTALL_PREFIX="/usr" \
	-DCMAKE_COLOR_MAKEFILE=OFF \
	-DBUILD_DOC=OFF \
    -DBUILD_DOCS=OFF \
	-DBUILD_EXAMPLE=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_TEST=OFF \
	-DBUILD_TESTS=OFF \
	-DBUILD_TESTING=OFF \
	-DBUILD_SHARED_LIBS=ON \
		-DCMAKE_Swift_FLAGS_DEBUG="" \
		-DCMAKE_Swift_FLAGS_RELEASE="" \
		-DCMAKE_Swift_FLAGS_RELWITHDEBINFO="" \

echo "Build Dispatch"
(cd $LIBDISPATCH_SRCDIR && ninja)
