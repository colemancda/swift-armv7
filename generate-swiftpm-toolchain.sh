#!/bin/bash
set -e
source swift-define

if [ $STATIC_SWIFT_STDLIB ]; then
    STATIC_SUFFIX="_static"
fi

echo "Generate SwiftPM cross compilation toolchain$STATIC_SUFFIX file"
rm -f ${SWIFTPM_DESTINATION_FILE}
mkdir -p $SRC_ROOT/build
touch ${SWIFTPM_DESTINATION_FILE}

printf "{\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   \"version\":1,\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   \"sdk\":\"${STAGING_DIR}\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   \"toolchain-bin-dir\":\"${SWIFT_NATIVE_PATH}\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   \"target\":\"${SWIFT_TARGET_NAME}\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   \"dynamic-library-extension\":\"so\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   \"extra-cc-flags\":[\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-fPIC\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-D_FILE_OFFSET_BITS=64\"\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   ],\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   \"extra-swiftc-flags\":[\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-target\", \"${SWIFT_TARGET_NAME}\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-use-ld=lld\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xcc\", \"--gcc-toolchain=${STAGING_DIR}/usr\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xlinker\", \"-rpath\", \"-Xlinker\", \"/usr/lib/swift$STATIC_SUFFIX/linux\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xlinker\", \"-rpath\", \"-Xlinker\", \"/usr/lib/swift$STATIC_SUFFIX/linux/${SWIFT_TARGET_ARCH}\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-resource-dir\", \"${STAGING_DIR}/usr/lib/swift$STATIC_SUFFIX\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-sdk\", \"${STAGING_DIR}\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-latomic\"\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   ],\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   \"extra-cpp-flags\":[\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-D_FILE_OFFSET_BITS=64\"\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   ]\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "}\n" >> ${SWIFTPM_DESTINATION_FILE}
