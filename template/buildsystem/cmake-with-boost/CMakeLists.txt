cmake_minimum_required(VERSION 3.17)
project(boost_template)

set(CMAKE_CXX_STANDARD 17)

add_executable(boost_template main.cpp)

# Use Boost
# https://cmake.org/cmake/help/v3.17/module/FindBoost.html
find_package(Boost 1.73.0
             REQUIRED COMPONENTS regex)
# Include Boost headers
include_directories(${Boost_INCLUDE_DIRS})
# Link any compiled Boost libraries (must be listed in components)
target_link_libraries(boost_template
                      PRIVATE Boost::regex)

