#message(STATUS "target: ${TARGET_TRIPLET} host: ${HOST_TRIPLET}")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Fundament-Software/scopes
    REF f8242fb1c9a077e11091197ba582ad5d7e685dd7
    SHA512 60d59f123935c0a7fde2139ffed43543afabda0f0c9b01c492c1dde11e71936188300784bdee0c3e5f07ded67a3a3f14110182847c66a0ec7de27b8f67cc9147
    HEAD_REF master
)

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        enable-address-sanitizer USE_ASAN_UBSAN
        target-webassembly TARGET_WEBASSEMBLY
        target-aarch64 TARGET_AARCH64
        target-riscv TARGET_RISCV
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    WINDOWS_USE_MSBUILD
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        ${FEATURE_OPTIONS}
        -DUSE_DEFAULT_FOLDERS=ON
)

vcpkg_cmake_install()

vcpkg_copy_pdbs()
vcpkg_copy_tools(TOOL_NAMES scopes AUTO_CLEAN)
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})

file(COPY ${CURRENT_PACKAGES_DIR}/lib/scopes DESTINATION ${CURRENT_PACKAGES_DIR}/tools/lib)
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# On windows, we compile with clang-cl, which is incompatible with the lib check: https://github.com/microsoft/vcpkg/pull/10398
if(${TARGET_TRIPLET} MATCHES "x*-windows*")
  set(VCPKG_POLICY_SKIP_ARCHITECTURE_CHECK enabled)
  set(VCPKG_POLICY_SKIP_DUMPBIN_CHECKS enabled)
endif()
