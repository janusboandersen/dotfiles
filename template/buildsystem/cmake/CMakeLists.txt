#use cmake to run the file or ccmake to get a visual overview of the build system (t for toggle advanced mode)

# Modern CMake should be higher than 2.8.12, but newer has more features...
cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

# ----- Project -----
#define name and version of project
project(myprojectname VERSION 0.1 LANGUAGES CXX)

#set the executable target and the source
add_executable(main main.cpp)


# ----- Global strictness -----
# There are some flags that you do not want to have localized, and in general
# you want to be at least as strict as every client you might deploy to
if (MSVC) #ensure support for MS Visual Studio
    #msvc style flags
    add_compile_options(/W4)
else()
    #unix style flags
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()


# ----- Header-only library -----
add_library(mylib INTERFACE)
target_include_directories(mylib INTERFACE include)
target_link_libraries(mylib INTERFACE Boost::Boost)


# ----- Header + binary library -----
## Add library and its implementation files
#add_library(mylib STATIC
#    src/file1.cpp
#    src/file2.cpp
#)

## Declare flags: Add HEADERS that we're using
target_include_directories(mylib PUBLIC include)
target_include_directories(mylib PRIVATE src)

## Declare flags: General pattern
#if (SOME_SETTING)
#target_compile_definitions(mylib
#    PUBLIC with_some_settings #if the setting should only affect the implementation, use PRIVATE
#)
#endif()

## Declare the dependencies
### Public (interface + implementation) dependencies
target_link_libraries(mylib PUBLIC abc)

### Private (implementation only) dependencies
target_link_libraries(mylib PRIVATE xyz)


# ----- XXXX -----
#require certain compile features, or language versions - see list:
#https://cmake.org/cmake/help/v3.10/manual/cmake-compile-features.7.html
#target_compile_features(cxx_constexpr)



#Embed a subdirectory, which gets built as standalone - must have own CMakeLists.txt
#add_subdirectory(my_source_dir my_binary_dir)



