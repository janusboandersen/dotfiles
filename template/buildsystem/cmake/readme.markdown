# https://github.com/Wigner-GPU-Lab/Teaching/tree/master/CMake/Lesson1_CompileC_CPP
# https://github.com/onqtam/awesome-cmake
# https://cmake.org/cmake/help/v3.10/manual/cmake-buildsystem.7.html
# https://rix0r.nl/blog/2015/08/13/cmake-guide/
# https://asmbits.blogspot.com/2017/06/idiomatic-cmake.html
# https://www.slideshare.net/DanielPfeifer1/cmake-48475415
# https://github.com/ttroy50/cmake-examples
# https://www.youtube.com/watch?v=eC9-iRN2b04

# Modern CMake
* Target-based buildsystem definition
* Single point of dependency
* Targets provide information to dependers
    * Requirements to compile
    * Requirements to link

# The idea behind Modern CMake is to help you focus on modules and dependencies instead of compiler flags
CMake is a generator to create a buildsystem (Makefile, Ninja, etc.), almost independent of platforms.

Let CMake take control of deciding when you need which flags, and instead focus on which modules are needed for your code. You define your project in terms of modular elements (= targets), their dependencies (= target link...), and the settings they need in order to work (= properties). CMake will help you keep the dependency graph clean, avoid circular dependencies, etc.

# Compatibility and specific behaviors (policies)
CMake has newer and better language features and behaviors the higher the version number. The modern era of CMake began with 2.8.12. The current latest version is 3.10 as of October 2017.

For compatibility, however, explicitly specifying a required version number allows requesting (and expecting) a certain set of behaviors, irrespective of the actual version of CMake installed (so you could run CMake 3.10 as if it were 2.8). Conversely, if the required version is higher than the available, the user will be notified.

Individual behaviors are called policies. A specific policy can be enabled, by requiring it by its policy number (CMPxxxx).

# Setting up a Modern CMake project: Guidelines
_Do_:
* Work (and think) with focus on targets and properties.
* Write target-centric code
    * Use `target_` command variants
    * Specify usage requirements for targets (INTERFACE PRIVATE PUBLIC)
* Consider portability and maintainability
    * Maintain up-to-date policy settings
* ...

_Don't_:
* Use functions that work directly on the directory structure:
    * `add_compile_options()`, `include_directories()`, `link_directories()`, `link_libraries()`.
* Write explicit compiler flags as settings - let CMake decide
* Use variables and globbing directly in the code (that should only be in the Makefile)

## Declare your project
You declare your project by something like `project(projectname VERSION 1.0.0 LANGUAGES CXX)`.

## Bring all required elements into scope
Your project has its own CMake file, wherein the project is declared. External libraries/modules that you depend on, either available system-wide (system installed) or just in your project repo, should be brought into scope for CMake to be aware of them... Whether for versioning requirements or for building. Nothing should be left unmentioned.

### Namespaces
Namespaces look like in C++. E.g. a dependency on the Boost library `program_options` can be referenced as `Boost::program_options`

### Public, Private, and Interface flags
Like the distinction between public and private in a class; A library consisting of a compiled binary (implementation) and a header (interface)  might need one set of flags to compile the binary (the implementation), and another set of flags (perhaps just a subset) in order to utilize or consume the header (the interface). Header-only libraries are not separately compiled.

Options/flags are scoped according to whether they act on interface, implementation, or both.
* INTERFACE is for the header / interface only.
* PRIVATE is for the binary / implementation only.
* PUBLIC is for both the interface and the implementation.

### Declare your module and its properties
Use `add_executable()` or `add_library()` to declare your module
* Use `target_xxx` to declare properties that are required by that module (e.g. flags)

### Declare your dependencies
Use `target_link_libraries()` to declare dependencies.

### System installed libraries
Use `find_package()` to bring these into scope, e.g. `find_package(Boost 1.40 COMPONENTS program_options REQUIRED)`.

### Libraries in your repo
These will hopefully have their own CMake file, and are brought into scope by ??? `add_subdirectory` or `add_library`??


`target_link_library`
`project`

