
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Fundament-Software/scopes
    REF e753e9b9ebefd13a6cad44dca0088fe12bc57e9e
    SHA512 0c769c9bdaaf359039398e163a9abf876aeeaf9c17b28c404f1baa236f6748055446be1c75778be7ba8883dacc4870c5d2f32109f47a41abcb5b3a2d4907dfda
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
