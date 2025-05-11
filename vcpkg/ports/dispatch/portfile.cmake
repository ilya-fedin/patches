vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO swiftlang/swift-corelibs-libdispatch
    REF swift-${VERSION}-RELEASE
    SHA512 c24bac36285c1efecb38ec861322700e1509ba5acd4bea0b4fb45f7cc3ff57b386f58a9718b99b641eaee8dfd55454bea4d77b2fa74a71c38d7a8f9616bfe2b5
    HEAD_REF main
    PATCHES werror.patch
)

string(REPLACE "-static-libasan" "-static-libsan" LDFLAGS "$ENV{LDFLAGS}")
set(ENV{LDFLAGS} "${LDFLAGS}")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_C_COMPILER=clang
        -DCMAKE_CXX_COMPILER=clang++
        -DCMAKE_C_FLAGS=-g
        -DCMAKE_CXX_FLAGS=-g
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
