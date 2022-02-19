# Configurable
source .config
source swift-define

set -e

# Build paths
SWIFT_SRCDIR=$SRC_ROOT/build/swift-swift-${SWIFT_VERSION}-RELEASE
LIBDISPATCH_SRCDIR=$SRC_ROOT/build/swift-corelibs-libdispatch-swift-${SWIFT_VERSION}-RELEASE
SWIFT_BUILDDIR=$SRC_ROOT/build/swift-armv7
SWIFTPM_DESTINATION_FILE=$SRC_ROOT/build/$SWIFT_TARGET_NAME-toolchain.json
SWIFT_CMAKE_TOOLCHAIN_FILE=$SRC_ROOT/build/linux-$SWIFT_TARGET_ARCH-toolchain.cmake

echo "Create Swift build folder ${SWIFT_BUILDDIR}"
rm -rf $SWIFT_BUILDDIR
mkdir -p $SWIFT_BUILDDIR

echo "Generate SwiftPM cross compilation toolchain file"
rm -f ${SWIFTPM_DESTINATION_FILE}
touch ${SWIFTPM_DESTINATION_FILE}
#printf "{\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "   "version":1,\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "   "sdk":"${STAGING_DIR}",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "   "toolchain-bin-dir":"${SWIFT_NATIVE_PATH}",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "   "target":"${SWIFT_TARGET_NAME}",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "   "dynamic-library-extension":"so",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "   "extra-cc-flags":[\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-fPIC"\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "   ],\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "   "extra-swiftc-flags":[\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-target", "${SWIFT_TARGET_NAME}",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-use-ld=lld",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-tools-directory", "/usr/bin",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-Xlinker", "-rpath", "-Xlinker", "/usr/lib/swift/linux",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-Xlinker", "-L${STAGING_DIR}",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-Xlinker", "-L${STAGING_DIR}/lib",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-Xlinker", "-L${STAGING_DIR}/usr/lib",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-Xlinker", "-L${STAGING_DIR}/usr/lib/swift/linux",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-Xlinker", "-L${STAGING_DIR}/usr/lib/swift/linux/${SWIFT_TARGET_ARCH}",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-Xlinker", "-L$(HOST_DIR)/lib/gcc/${SWIFT_TARGET_NAME}/$(call qstrip,$(BR2_GCC_VERSION))",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-Xlinker", "--build-id=sha1",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-I${STAGING_DIR}/usr/include",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-I${STAGING_DIR}/usr/lib/swift",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-resource-dir", "${STAGING_DIR}/usr/lib/swift",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-Xclang-linker", "-B${STAGING_DIR}/usr/lib",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-Xclang-linker", "-B$(HOST_DIR)/lib/gcc/${SWIFT_TARGET_NAME}/$(call qstrip,$(BR2_GCC_VERSION))",\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-sdk", "${STAGING_DIR}"\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "   ],\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "   "extra-cpp-flags":[\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "      "-lstdc++"\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "   ]\n" >> ${SWIFTPM_DESTINATION_FILE}
#printf "}\n" >> ${SWIFTPM_DESTINATION_FILE}


echo "Generate cmake toolchain"
rm -f ${SWIFT_CMAKE_TOOLCHAIN_FILE}
touch ${SWIFT_CMAKE_TOOLCHAIN_FILE}
	printf "set(CMAKE_SYSTEM_NAME Linux)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
	printf "set(CMAKE_C_COMPILER $SWIFT_NATIVE_PATH/clang)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(CMAKE_CXX_COMPILER ${SWIFT_NATIVE_PATH}/clang++)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(CMAKE_C_FLAGS \"-w -fuse-ld=lld -target ${SWIFT_TARGET_NAME} --sysroot ${STAGING_DIR} -march=armv7-a -mfpu=neon -mfloat-abi=hard -I${STAGING_DIR}/usr/include -I${STAGING_DIR}/usr/include/arm-linux-gnueabihf -B${STAGING_DIR}/usr/lib -B${STAGING_DIR}/usr/lib/arm-linux-gnueabihf -B${STAGING_DIR}/lib -B${STAGING_DIR}/lib/arm-linux-gnueabihf -B${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10 -L${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10 \")\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
	printf "set(CMAKE_C_LINK_FLAGS \"-target ${SWIFT_TARGET_NAME} --sysroot ${STAGING_DIR} -march=armv7-a -mfpu=neon -mfloat-abi=hard \")\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(CMAKE_CXX_FLAGS \"-w -fuse-ld=lld -target ${SWIFT_TARGET_NAME} --sysroot ${STAGING_DIR} -march=armv7-a -mfpu=neon -mfloat-abi=hard -I${STAGING_DIR}/usr/include -I${STAGING_DIR}/usr/include/arm-linux-gnueabihf -B${STAGING_DIR}/usr/lib -B${STAGING_DIR}/usr/lib/arm-linux-gnueabihf -B${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10 -L${STAGING_DIR}/usr/lib/gcc/arm-linux-gnueabihf/10 \")\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(CMAKE_CXX_LINK_FLAGS \"-target ${SWIFT_TARGET_NAME} --sysroot ${STAGING_DIR} -march=armv7-a -mfpu=neon -mfloat-abi=hard \")\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
	printf "set(SWIFT_USE_LINKER lld)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(LLVM_USE_LINKER lld)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(LLVM_DIR ${SWIFT_LLVM_DIR}/lib/cmake/llvm)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(LLVM_BUILD_LIBRARY_DIR ${SWIFT_LLVM_DIR})\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(LLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN ON)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
	printf "set(SWIFT_INCLUDE_TOOLS OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER ON)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
	printf "set(SWIFT_PREBUILT_CLANG ON)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_NATIVE_CLANG_TOOLS_PATH ${SWIFT_NATIVE_PATH})\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
	printf "set(SWIFT_NATIVE_LLVM_TOOLS_PATH ${SWIFT_NATIVE_PATH})\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_NATIVE_SWIFT_TOOLS_PATH ${SWIFT_NATIVE_PATH})\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_BUILD_AST_ANALYZER OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_BUILD_DYNAMIC_SDK_OVERLAY ON)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_BUILD_DYNAMIC_STDLIB ON)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_BUILD_REMOTE_MIRROR OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_BUILD_SOURCEKIT OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_BUILD_STDLIB_EXTRA_TOOLCHAIN_CONTENT OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_BUILD_SYNTAXPARSERLIB OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_BUILD_REMOTE_MIRROR OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_ENABLE_SOURCEKIT_TESTS OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_INCLUDE_DOCS OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_INCLUDE_TOOLS OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_INCLUDE_TESTS OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_LIBRARY_EVOLUTION 0)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_RUNTIME_OS_VERSIONING OFF)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_HOST_VARIANT_ARCH ${SWIFT_TARGET_ARCH})\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_SDKS LINUX)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_PATH ${STAGING_DIR} )\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_LIBC_INCLUDE_DIRECTORY ${STAGING_DIR}/usr/include )\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_LIBC_ARCHITECTURE_INCLUDE_DIRECTORY ${STAGING_DIR}/usr/include/arm-linux-gnueabihf )\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_LINUX_${SWIFT_TARGET_ARCH}_ICU_I18N ${STAGING_DIR}/usr/lib/libicui18n.so)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(SWIFT_LINUX_${SWIFT_TARGET_ARCH}_ICU_UC ${STAGING_DIR}/usr/lib/libicuuc.so)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(ICU_I18N_LIBRARIES ${STAGING_DIR}/usr/lib/libicui18n.so)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
    printf "set(ICU_UC_LIBRARIES ${STAGING_DIR}/usr/lib/libicuuc.so)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
	printf "set(LibRT_LIBRARIES ${STAGING_DIR}/usr/lib/librt.a)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
	printf "set(ZLIB_LIBRARY ${STAGING_DIR}/usr/lib/libz.so)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
	printf "set(SWIFT_PATH_TO_LIBDISPATCH_SOURCE ${LIBDISPATCH_SRCDIR})\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}
	printf "set(SWIFT_ENABLE_EXPERIMENTAL_CONCURRENCY ON)\n" >> ${SWIFT_CMAKE_TOOLCHAIN_FILE}

echo "Configure Swift"
rm -rf $SWIFT_BUILDDIR/CMakeCache.txt
LIBS="-latomic" cmake -S $SWIFT_SRCDIR -B $SWIFT_BUILDDIR -G Ninja \
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
		-DCMAKE_CROSSCOMPILING=ON \
		-DCMAKE_TOOLCHAIN_FILE=$SWIFT_CMAKE_TOOLCHAIN_FILE \
		-DCMAKE_BUILD_TYPE=Release \
		-DSWIFT_USE_LINKER=lld \
        -DLLVM_USE_LINKER=lld \
        -DLLVM_DIR=${SWIFT_LLVM_DIR}/lib/cmake/llvm \
        -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON \
        -DSWIFT_BUILD_RUNTIME_WITH_HOST_COMPILER=ON \
        -DSWIFT_NATIVE_CLANG_TOOLS_PATH=$SWIFT_NATIVE_PATH \
        -DSWIFT_NATIVE_SWIFT_TOOLS_PATH=$SWIFT_NATIVE_PATH \
        -DSWIFT_BUILD_AST_ANALYZER=OFF \
        -DSWIFT_BUILD_DYNAMIC_SDK_OVERLAY=ON \
        -DSWIFT_BUILD_DYNAMIC_STDLIB=ON \
        -DSWIFT_BUILD_REMOTE_MIRROR=OFF \
        -DSWIFT_BUILD_SOURCEKIT=OFF \
        -DSWIFT_BUILD_STDLIB_EXTRA_TOOLCHAIN_CONTENT=OFF \
        -DSWIFT_BUILD_SYNTAXPARSERLIB=OFF \
        -DSWIFT_BUILD_REMOTE_MIRROR=OFF \
        -DSWIFT_ENABLE_SOURCEKIT_TESTS=OFF \
        -DSWIFT_INCLUDE_DOCS=OFF \
        -DSWIFT_INCLUDE_TOOLS=OFF \
        -DSWIFT_INCLUDE_TESTS=OFF \
        -DSWIFT_LIBRARY_EVOLUTION=0 \
        -DSWIFT_RUNTIME_OS_VERSIONING=OFF \
        -DSWIFT_HOST_VARIANT_ARCH=$SWIFT_TARGET_ARCH \
        -DSWIFT_SDKS=LINUX \
        -DSWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_PATH=${STAGING_DIR}  \
        -DSWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_LIBC_INCLUDE_DIRECTORY=${STAGING_DIR}/usr/include  \
        -DSWIFT_SDK_LINUX_ARCH_${SWIFT_TARGET_ARCH}_LIBC_ARCHITECTURE_INCLUDE_DIRECTORY=${STAGING_DIR}/usr/include/arm-linux-gnueabihf \
        -DSWIFT_LINUX_${SWIFT_TARGET_ARCH}_ICU_I18N=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libicui18n.so \
        -DSWIFT_LINUX_${SWIFT_TARGET_ARCH}_ICU_UC=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libicuuc.so \
        -DICU_I18N_LIBRARIES=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libicui18n.so \
        -DICU_UC_LIBRARIES=${STAGING_DIR}/usr/lib/arm-linux-gnueabihf/libicuuc.so \

echo "Build Swift StdLib"
(cd $SWIFT_BUILDDIR && ninja)

echo "Copy Swift StdLib"
# Copy runtime libraries and swift interfaces
sudo cp -rf ${SWIFT_BUILDDIR}/lib/swift ${STAGING_DIR}/usr/local/lib/
