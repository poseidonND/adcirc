# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.26

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /afs/crc.nd.edu/x86_64_linux/c/cmake/3.26.4/bin/cmake

# The command to remove a file.
RM = /afs/crc.nd.edu/x86_64_linux/c/cmake/3.26.4/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/cmake

# Include any dependencies generated for this target.
include CMakeFiles/mkdir.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/mkdir.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/mkdir.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/mkdir.dir/flags.make

CMakeFiles/mkdir.dir/prep/mkdir.c.o: CMakeFiles/mkdir.dir/flags.make
CMakeFiles/mkdir.dir/prep/mkdir.c.o: /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/prep/mkdir.c
CMakeFiles/mkdir.dir/prep/mkdir.c.o: CMakeFiles/mkdir.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/cmake/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/mkdir.dir/prep/mkdir.c.o"
	/opt/crc/i/intel/18.0/bin/icc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/mkdir.dir/prep/mkdir.c.o -MF CMakeFiles/mkdir.dir/prep/mkdir.c.o.d -o CMakeFiles/mkdir.dir/prep/mkdir.c.o -c /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/prep/mkdir.c

CMakeFiles/mkdir.dir/prep/mkdir.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/mkdir.dir/prep/mkdir.c.i"
	/opt/crc/i/intel/18.0/bin/icc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/prep/mkdir.c > CMakeFiles/mkdir.dir/prep/mkdir.c.i

CMakeFiles/mkdir.dir/prep/mkdir.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/mkdir.dir/prep/mkdir.c.s"
	/opt/crc/i/intel/18.0/bin/icc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/prep/mkdir.c -o CMakeFiles/mkdir.dir/prep/mkdir.c.s

# Object files for target mkdir
mkdir_OBJECTS = \
"CMakeFiles/mkdir.dir/prep/mkdir.c.o"

# External object files for target mkdir
mkdir_EXTERNAL_OBJECTS =

CMakeFiles/libmkdir.a: CMakeFiles/mkdir.dir/prep/mkdir.c.o
CMakeFiles/libmkdir.a: CMakeFiles/mkdir.dir/build.make
CMakeFiles/libmkdir.a: CMakeFiles/mkdir.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/cmake/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C static library CMakeFiles/libmkdir.a"
	$(CMAKE_COMMAND) -P CMakeFiles/mkdir.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/mkdir.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/mkdir.dir/build: CMakeFiles/libmkdir.a
.PHONY : CMakeFiles/mkdir.dir/build

CMakeFiles/mkdir.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/mkdir.dir/cmake_clean.cmake
.PHONY : CMakeFiles/mkdir.dir/clean

CMakeFiles/mkdir.dir/depend:
	cd /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/cmake && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/cmake /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/cmake /asclepius/atejaswi/ADCIRC-Versions/hydrology_for_main/adcirc/cmake/CMakeFiles/mkdir.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/mkdir.dir/depend

