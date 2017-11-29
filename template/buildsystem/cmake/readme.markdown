
# Modern CMake
* Target-based buildsystem definition
* Single point of dependency
* Targets provide information to dependers
    * Requirements to compile
    * Requirements to link

# The idea behind Modern CMake is to help you focus on build-targets and their dependencies instead of compiler flags
CMake is a generator to create a buildsystem (Makefile, Ninja, etc.), almost independent of platforms.

Let CMake take control of deciding when you need which flags, and instead focus on which modules are needed for your code. You define your project in terms of modular elements (= targets), their dependencies (= target link...), and the settings they need in order to work (= properties).

Using CMake will force good-practice modular source code management. CMake will help you keep the dependency graph clean, avoid circular dependencies, etc.

# Compatibility and specific behaviors (policies)
CMake has newer and better language features and behaviors the higher the version number. The modern era of CMake began with 2.8.12. The current latest version is 3.10 as of October 2017.

For compatibility, however, explicitly specifying a required version number allows requesting (and expecting) a certain set of behaviors, irrespective of the actual version of CMake installed (so you could run CMake 3.10 as if it were 2.8). Conversely, if the required version is higher than the available, the user will be notified.

Individual behaviors are called policies. A specific policy can be enabled, by requiring it by its policy number (CMPxxxx).

# A Modern CMake project: Guidelines
_Do_:
* Work (and think) with focus on targets and properties.
* Write target-centric code
    * Use `target_` command variants
    * Specify usage requirements for targets (INTERFACE PRIVATE PUBLIC)
* Consider portability and maintainability
    * Maintain up-to-date policy settings
* ...

_Don't_:
* Use functions that affect compilation settings for all targets (because it becomes hard to reason about and hard to manage, and doesn't scale well):
    * `add_compile_options()`, `include_directories()`, `link_directories()`, `link_libraries()`.
* Write explicit compiler flags as settings (instead let CMake decide to maintain portability and flexibility)
* Use variables in the CMake spec (because it introduces the risk for hard to debug errors - e.g. a mis-spelled variable name resolves to blank text)
* Use file globbing directly in the CMake spec (because it doesn't add the flexibility that you think, the buildsystem Makefile doesn't get affected when files are added, yet it introduces non-target-focused code).

## Declare your project
You declare your project by something like `project(projectname VERSION 1.0.0 LANGUAGES CXX)`.

## Bring all required elements into scope
Your project has its own CMake file, wherein the project is declared. External libraries/modules that you depend on, either available system-wide (system installed) or just in your project repo, should be brought into scope for CMake to be aware of them... Whether for versioning requirements or for building. Nothing should be left unmentioned.

### Declare your targets and their properties
Use `add_executable()` or `add_library()` to declare your module
* Use `target_xxx` to declare dependencies and properties that are required by that target (e.g. compiler features, libraries, etc.)
* Use <PUBLIC|PRIVATE|INTERFACE> to set scope of dependency or property

### CMake Target types
| Target type         | Function call            |
|---------------------|--------------------------|
| Executables         | `add_executable`         |
| Shared libraries    | `add_library(SHARED)`    |
| Static libraries    | `add_library(STATIC)`    |
| Object libraries    | `add_library(OBJECT)`    |
| Interface libraries | `add_library(INTERFACE)` |
| Alias libraries     | `add_library(ALIAS)`     |

The _interface libraries_ and _alias libraries_ are CMake concepts.
* An interface library is one that does not build anything, suitable for a header-only dependency. See that section.
* An alias library target is clarification / namespaced re-definition of a target (hence alias). See section "Using namespaces".

    * See section "Using namespaces"

### Public, Private, and Interface
Like the distinction between public and private in a class; A library consisting of a compiled binary (implementation) and a header (interface)  might need one set of flags to compile the binary (the implementation), and another set of flags (perhaps just a subset) in order to utilize or consume the header (the interface). Header-only libraries are not separately compiled.

Options/flags are scoped according to whether they act on interface, implementation, or both.
* INTERFACE is for the header / interface only.
* PRIVATE is for the binary / implementation only.
* PUBLIC is for both the interface and the implementation.

### Using namespaces
Namespaces look like in C++. For example, a dependency for the Boost library `program_options` is typically referenced as `Boost::program_options`. This is useful for specifying library names and their components in an easy, portable way. Namespaces are actually "Alias libraries". See section "CMake Target types".

* A namespace is an alias library target. As such, it is a clarification / namespaced re-definition of a target (hence alias)
    * Declare it as:
        * `add_library(detail::platform_specific ALIAS platform_specific)`
    * Consume it as:
        * `target_link_libraries(mytarget detail::platform_specific)`

The advantage:
* Dependencies specified with `::` are interpreted as *definitely* being a CMake target, and so an error will *definitely* be thrown if it doesn't exists (i.e. it doesn't just delegate to the compiler to find a library somewhere).
* Most external libraries that are found using `find_library()` will provide such namespaced facilities. See section on external / system-wide libraries.

### Declare your target's dependencies
Use `target_link_libraries(some_target <item>)` to declare dependencies. 
* This function declares a dependency between one target and zero-to-many other targets.
* This could be between your executable (target1) and a library (target2), which you may or may not be building concurrently with your executable. 
* Target2 may also have it's own dependencies, and then the dependency graph expands.

`<item>` can be (and is resolved in this order):
* A CMake target
* A linker flag (prefixes a hyphen `-` to pass the flag `-WhateverYouTyped` to the compiler/linker)
* A full library path (that can be checked)
* A library name on disk (prefixes `-l` to give `-lWhateverYouTyped` and passes this to let the compiler/linker handle it...)

Also:
* Remember scoping

Example:
* `target_link_libraries(some_target another_target)`

Results:
* Link to `another_target`
* Determine build order
* Consume usage requirements
    * Compiling
    * Linking
* Determine compatibility

#### Header-only dependencies (-> INTERFACE target types)
to do
    * Declare it as:
        * `add_library(boost_mpl INTERFACE)`
        * `target_compile_definitions(boost_mpl INTERFACE BOOST_MPL_NO_PREPROCESSED_HEADERS)`
        * `target_include_directories(boost_mpl INTERFACE "3rdparty/boost/mpl")`
    * Consume it as:
        * `target_link_libraries(my_exe boost_mpl)`

#### Libraries in your repo (-> STATIC, OBJECT or SHARED target types)
These will either (hopefully) have their own CMake file - then use `add_subdirectory()` to bring that recipe into scope. and are brought into scope by ??? `add_subdirectory` or `add_library`??

#### System installed/external libraries (-> SHARED target types)
Use `find_package()` to bring these into scope, e.g. `find_package(Boost 1.40 COMPONENTS program_options REQUIRED)`. Probably is available as `Boost::program_options` afterwards.

# CMake system

## CMake works in three phases
1. *Configure*: Parses the CMakeLists.txt file(s). Any if/else expressions are evaluated here. Variables are expanded during this phase.
2. *Compute*: Computes the dependencies. Generator expressions `$<bool:...>` are evaluated after this phase.
3. *Generate*: Makes the actual buildsystem files (Makefile, etc.)

## CMake language features
CMake has its own macro language (oh no, yet another language...).
* `${variable_name}` expands / inserts the variable's value. Try to avoid using this in new projects.
* `if(condition)` / `else()` / `endif()`
* `$<boolean:...>` generator expression is a conditional variable. These can be used inside commands. Examples:
    * `$<1:...>` will always return ...
    * `$<0:...>` will never return ...
    * `$<Config:Debug>` will return 1 in Debug config or 0 otherwise.
    * Can be nested: `$<$<Config:Debug>:...>` will return ... if in debug mode
    * Can use variables (variables are expanded in configure phase):
        * Configure phase: `$<$<BOOL:${WIN32}>: ...>` becomes
        * Generate phase: `$<$<BOOL:1>:...>` (true) or `$<$<BOOL:>...>` (false)
    * Read a property at generate time that is set at configure time:
        * `$<$<TARGET_PROPERTY:WITH_THREADS>:USE_THREADS>` could be used inside a command like target_compile_definitions(hello PRIVATE ...) and will reflect set_property(TARGET hello PROPERTY WITH_THREDS ON)

# Resources and inspiration
[](https://github.com/Wigner-GPU-Lab/Teaching/tree/master/CMake/Lesson1_CompileC_CPP)
[](https://github.com/onqtam/awesome-cmake)
[](https://cmake.org/cmake/help/v3.10/manual/cmake-buildsystem.7.html)
[](https://rix0r.nl/blog/2015/08/13/cmake-guide/)
[](https://asmbits.blogspot.com/2017/06/idiomatic-cmake.html)
[](https://www.slideshare.net/DanielPfeifer1/cmake-48475415)
[](https://github.com/ttroy50/cmake-examples)
[](https://www.youtube.com/watch?v=eC9-iRN2b04)
