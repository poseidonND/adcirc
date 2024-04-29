# Install script for directory: /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib64" TYPE STATIC_LIBRARY FILES "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/cmake/CMakeFiles/libjasper.a")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/jasper" TYPE FILE FILES
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_cm.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/cmake/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_config.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_debug.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_dll.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_fix.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_getopt.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_icc.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_image.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_init.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_malloc.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_math.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jasper.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_seq.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_stream.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_string.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_tmr.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_tvp.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_types.h"
    "/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/thirdparty/wgrib2/jasper/src/libjasper/include/jasper/jas_version.h"
    )
endif()

