#!/bin/bash
set -e
source swift-define

echo "Generate SwiftPM cross compilation toolchain file"
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
printf "      \"-fPIC\"\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   ],\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   \"extra-swiftc-flags\":[\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-target\", \"${SWIFT_TARGET_NAME}\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-use-ld=lld\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-tools-directory\", \"${SWIFT_NATIVE_PATH}\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xlinker\", \"-rpath\", \"-Xlinker\", \"/usr/lib/swift/linux\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xlinker\", \"-rpath\", \"-Xlinker\", \"/usr/lib/swift/linux/${SWIFT_TARGET_ARCH}\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xlinker\", \"-L${STAGING_DIR}\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xlinker\", \"-L${STAGING_DIR}/lib\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xlinker\", \"-L${STAGING_DIR}/usr/lib\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xlinker\", \"-L${STAGING_DIR}/usr/lib/swift\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xlinker\", \"-L${STAGING_DIR}/usr/lib/swift/linux\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xlinker\", \"-L${STAGING_DIR}/usr/lib/swift/linux/${SWIFT_TARGET_ARCH}\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xlinker\", \"--build-id=sha1\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-I${STAGING_DIR}/usr/include\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-I${STAGING_DIR}/usr/lib/swift\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-resource-dir\", \"${STAGING_DIR}/usr/lib/swift\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xclang-linker\", \"-B${STAGING_DIR}/usr/lib\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-Xfrontend\", \"-cxx-interoperability-mode=default\",\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "      \"-sdk\", \"${STAGING_DIR}\"\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   ],\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   \"extra-cpp-flags\":[\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "   ]\n" >> ${SWIFTPM_DESTINATION_FILE}
printf "}\n" >> ${SWIFTPM_DESTINATION_FILE}