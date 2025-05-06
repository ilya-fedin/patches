set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)
set(VCPKG_BUILD_TYPE release)

if (PORT MATCHES "breakpad|ffmpeg|libvpx")
    set(ENV{CFLAGS} "$ENV{CFLAGS} -fno-lto")
    set(ENV{CXXFLAGS} "$ENV{CXXFLAGS} -fno-lto")
endif()

if (PORT STREQUAL ffmpeg)
    set(ENV{LDFLAGS} "$ENV{LDFLAGS} -Wl,--push-state,--no-as-needed,-lstdc++,--pop-state")
endif()
