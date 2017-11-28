#use cmake to run the file or ccmake to get a visual overview of the build system (t for toggle advanced mode)

cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

#define name and version of project
project(my_project_name VERSION my_version_number LANGUAGES CXX)

#set the executable target and the source
add_executable(main.exe main.cpp)

#require certain compile features, or language versions - see list:
#https://cmake.org/cmake/help/v3.10/manual/cmake-compile-features.7.html
#target_compile_features(cxx_constexpr)

#enable compiler options like warning flags
#ensure support for MS Visual Studio
if (MSVC)
    #msvc style flags
    add_compile_options(/W4)
else()
    #unix style flags
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

#add libraries (static, shared, module or interface)
#add_library(foo STATIC foo1.cpp foo2.cpp)

#Embed a subdirectory, which gets built as standalone - must have own CMakeLists.txt
#add_subdirectory(my_source_dir my_binary_dir)



