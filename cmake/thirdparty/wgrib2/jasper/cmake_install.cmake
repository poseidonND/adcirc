# Install script for directory: /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE PROGRAM FILES
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libchkp.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libcilkrts.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libcilkrts.so.5"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libimf.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libintlc.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libintlc.so.5"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libirc.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libpdbx.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libpdbx.so.5"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libsvml.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libirng.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/liboffload.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/liboffload.so.5"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/cilk_db.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libistrconv.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libgfxoffload.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libioffload_host.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libioffload_host.so.5"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libioffload_target.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libioffload_target.so.5"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libmpx.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/offload_main"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libicaf.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libifcore.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libifcore.so.5"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libifcoremt.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libifcoremt.so.5"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libifport.so"
    "/opt/crc/i/intel/18.0/bin/../lib/intel64/libifport.so.5"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE DIRECTORY FILES "")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib64/pkgconfig" TYPE FILE FILES "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/cmake/thirdparty/wgrib2/jasper/build/jasper.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/doc/adcirc" TYPE FILE FILES "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/README")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/cmake/thirdparty/wgrib2/jasper/src/libjasper/cmake_install.cmake")

endif()

