# Makefile template that supports different source and build directories
# Automatic search and rule generation
#
# This file is intended for GNU Make (gmake), but probably works for all POSIX
# See: https://www.gnu.org/software/make/manual/make.html
#
# Inspiration from:
# https://spin.atomicobject.com/2016/08/26/makefile-c-projects/
# https://hiltmon.com/blog/2013/07/03/a-simple-c-plus-plus-project-structure/
#
# Filetypes:
# Source: .c (C code), .cpp (C++ code), .s (assembly code) 
# Compiled: .o (object file), .so (shared object - dyn lib), .a (static library), 
#
# Flags:
# Pre-processor: CPPFLAGS (C pre-processor flags), 
# Compiler: CFLAGS (C compile flags), CXXFLAGS (C++ compile flags), ASFLAGS (Assembly compile flags) 
# Linker: LDFLAGS (Linker flags), 
#
# Make language
# Wildcards: * (*.c is a list of all files that end in .c), % (prefix%suffix is a pattern to match)
# Assignment operators:  += (append)  := (simply expanded)  ?= (conditional assignment, if ndef) 
# $@ expands to the filename of the target, $< expands to the name of the first prerequisite


# ----- Target, build directory and source directory -----
# set target executable file. It will be compiled into the build dir
TARGET_EXEC ?= a.out

# Set directories for placing built files and intermediate object files 
BUILD_DIR ?= ./build

# Set directory to search for source code
SRC_DIRS ?= ./src


# ----- Compilers and versions -----
# These need likely not be explicitly defined, but are done so here for stability
# Using GNU compilers as they seem to produce similar results across platforms
# On Mac OS, gcc and g++ are wrapped by Clang

# C compiler and flags
CC := gcc

# C++ compiler and flags
CXX := g++
# CXX_FLAGS := -Wall -Werror -std=c++11


# ----- Build dependency / prequisites tree -----

# Source code filenames to map in dependency tree and to compile
SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)

# Object file names to map in dependency tree and to give to linker 
# Prefixes the build_dir, and postfixes .o (main.cpp -> build/main.cpp.o)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

# Dependency list files, one dependency file per source file (main.cpp.o -> main.cpp.d)
DEPS := $(OBJS:.o=.d)


# ----- Pre-processor -----
# Specify include directories to search for header files during pre-processing
INC_DIRS := $(shell find $(SRC_DIRS) -type d)

# Build the flag for all custom include directories ( -I<dir1> -I<dir2> -I<dir3> ... )
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# Build list of flags for the pre-processer
# -MMD -MP: Have the pre-processor write dependencies to file 
CPPFLAGS ?= $(INC_FLAGS) -MMD -MP


# ----- Define build rules:  -----
# Here we use pattern rules to dynamically generate files of prerequisites (ie. Makefiles)
# A rule with multiple targets is equivalent to writing many rules
# The preprocessor will create these dependency list files
#
# target: prerequisites
#	recipe (like: gcc main.o helper.o -o my_executable -I<directory> -l<dynlib> )

# Link all the object files into an executable
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

# Assembly code to object files
$(BUILD_DIR)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# C source to object files
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# C++ source to object files
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


# ----- Clean up recipe -----
# Clean is a phony target, not a build target!
.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)


# ----- Compiling dependencies -----
# Run the dependency list files created by the preprocessor for each prerequisite
-include $(DEPS)


# ----- Helper functions -----
# Use MKDIR_P to invoke shell to recursively build path
MKDIR_P ?= mkdir -p
