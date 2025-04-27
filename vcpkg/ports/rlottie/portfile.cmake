vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO desktop-app/rlottie
        REF ${VERSION}
        SHA512 3100ef9985aba67bcbea294f6841b30b6ae89d33a5b1ac8058acf23ff3d0c2a169aa2c976d227fb9dea0a4a021fb8a37b0e988b1128fece1e194b30d0171791b
        HEAD_REF master
)

file(REMOVE_RECURSE "${SOURCE_PATH}/src/lottie/rapidjson")

vcpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}"
        OPTIONS
            -DLIB_INSTALL_DIR=lib
            -DLOTTIE_MODULE=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/rlottie")
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING" "${SOURCE_PATH}/AUTHORS")
