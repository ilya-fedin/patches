set(VCPKG_POLICY_ALLOW_EMPTY_FOLDERS enabled)
set(URL "https://github.com/desktop-app/tg_owt.git")
set(SOURCE_PATH "${CURRENT_BUILDTREES_DIR}/src/")
if (VCPKG_USE_HEAD_VERSION)
    cmake_path(APPEND_STRING SOURCE_PATH "head/")
endif()
cmake_path(APPEND_STRING SOURCE_PATH "${VERSION}")
if (NOT _VCPKG_EDITABLE)
    cmake_path(APPEND_STRING SOURCE_PATH ".clean")
endif()

function(clone)
    if (EXISTS "${SOURCE_PATH}")
        if (_VCPKG_EDITABLE)
            message(STATUS "Using source at ${SOURCE_PATH}")
            return()
        else()
            message(STATUS "Cleaning sources at ${SOURCE_PATH}. Use --editable to skip cleaning for the packages you specify.")
            file(REMOVE_RECURSE "${SOURCE_PATH}")
        endif()
    endif()

    find_program(GIT git REQUIRED)

    message(STATUS "Cloning ${URL}")
    vcpkg_execute_required_process(
        COMMAND ${GIT} clone ${URL} ${SOURCE_PATH}
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}"
        LOGNAME clone
    )

    if (NOT VCPKG_USE_HEAD_VERSION)
        message(STATUS "Checking out revision ${VERSION}")
        vcpkg_execute_required_process(
            COMMAND ${GIT} checkout ${VERSION}
            WORKING_DIRECTORY "${SOURCE_PATH}"
            LOGNAME checkout
        )
    endif()

    message(STATUS "Updating submodules")
    vcpkg_execute_required_process(
        COMMAND ${GIT} submodule update --init --recursive
        WORKING_DIRECTORY "${SOURCE_PATH}"
        LOGNAME submodules
    )
endfunction()

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

clone()

vcpkg_find_acquire_program(PKGCONFIG)
set(ENV{PKG_CONFIG} "${PKGCONFIG}")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS -DTG_OWT_DLOPEN_PIPEWIRE=ON
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME "tg_owt" CONFIG_PATH "lib/cmake/tg_owt")

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
