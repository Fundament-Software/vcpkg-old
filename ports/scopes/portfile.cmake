#message(STATUS "target: ${TARGET_TRIPLET} host: ${HOST_TRIPLET}")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Fundament-Software/scopes
    REF 4998c6d531259d9087cf26b486cbf7fa3d4e4e9b
    SHA512 dfd17ae1a7671103d3ef04461e0ecce16a5fa26bb836f7f4b1e9a1b4da0ddda44fa8c11bc7df54e676b3f7ef1f558bf9d97b946f4a180082a35f2e3da66d4a53
    HEAD_REF master
)

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        enable-address-sanitizer USE_ASAN_UBSAN
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    WINDOWS_USE_MSBUILD
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
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
