# Top-level CMake file
# Purpose: bring all modules into scope
#   - add all subdirectories in the tree
#   - find external targets (e.g. Boost), and turn them into imported targets

# CMake version requirement
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

# Project details
project(myproject VERSION 0.1 LANGUAGES CXX)

# Use GNU Install dirs
#include(GNUInstallDirs)

# Include Boost as imported target
find_package(Boost REQUIRED)



#Tutorial
#Don't use these: add_compile_options(), include_directories(), link_directories(), link_libraries()
#Avoid variables and globbing (it's okay in the Makefile, not in the generator)
