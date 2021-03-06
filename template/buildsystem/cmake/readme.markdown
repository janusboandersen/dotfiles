# CMake
* Build software (cmake)
* Package software (cpack)
* Test software (ctest)


# Modern CMake
* Target-based buildsystem definition
* Single point of dependency
* Targets provide information to dependers
    * Requirements to compile
    * Requirements to link


# The idea behind Modern CMake is to help you focus on build-targets and their dependencies instead of compiler flags
CMake is a generator to create a buildsystem (Makefile, Ninja, etc.), almost independent of platforms. CMake is also used for packaging software for installation on other platforms.

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

## Bring all relevant elements into scope
* Your project has its own CMake file (CMakeLists.txt), wherein the project is declared, and the ultimate build-target (executable) is declared.
* All external libraries that your project depends on, either available system-wide (system installed) or from within your own project repo, should be brought into scope for CMake to be aware of them (from #include header-only dependencies to the entire Boost library)
* In the context of CMake, all dependencies are also targets per se, and a complete dependency graph must be built for the entire project.
* Nothing should be left unmentioned: Whether for outright building, for making an installer, or just for managing versioning requirements.


### CMake Target types
CMake targets should be understood as ultimate binary targets, i.e. anything that will end up being in binary form for your project to run.

| Target type         | Function call            | Details                           |
|---------------------|--------------------------|-----------------------------------|
| Executables         | `add_executable()`       | Will need an entry point          |
| Static libraries    | `add_library(STATIC)`    | (default) Linker-embedded lib.    |
| Shared libraries    | `add_library(SHARED)`    | Can be marked FRAMEWORK for Mac   |
| Object libraries    | `add_library(OBJECT)`    | Non-linked, use only as source $<>|
| Interface libraries | `add_library(INTERFACE)` | Non-compiled, header-only         |
| Alias libraries     | `add_library(ALIAS)`     | Namespacing, re-definition        |

The _interface libraries_ and _alias libraries_ are CMake concepts.
* An interface library is one that does not build anything, suitable for a header-only dependency. See that section.
* An alias library target is clarification / namespaced re-definition of a target (hence alias). See section "Using namespaces".


### Declare your targets
Use `add_executable()` or `add_library()` to declare your targets.
* See available CMake target types above.
* Use functions with signatures like `target_xxx` to declare dependencies and properties that are required by that target (e.g. compiler features, linked libraries, etc.).
* Use the modes <PUBLIC|PRIVATE|INTERFACE> to set scope of any property.

Example:
* `add_executable(my_exe main.cpp)`


### Declare your target's properties / requirements
Use functions with signatures like `target_xxx(my_target <mode> <item>)` to declare properties, requirements or dependencies for a given target (e.g. compiler features, linked libraries, etc.).

Repeated calls for the same target will append items.

Modern CMake prefers to set minimum requirements for the feature sets your code needs, rather than setting explicit compiler flags, in order to maintain flexibility. Explicit flags will vary across compilers, and perhaps such flags are overly restrictive. For example, setting `-std=c++11` prevents using the C++17 standard automatically later, if that should become relevant.

`<mode>`: refers to the modes <PUBLIC|PRIVATE|INTERFACE> thath set scope of any property. See section below.
`<item>`: refers to a requirement or property that is needed. See examples below. And see the reference manual online. 


| Target requirement        | Function call                   | `<item>`      | `<item>` result example   |
|---------------------------|---------------------------------|---------------|---------------------------|
| Compiler features         | `target_compile_features()`     |`cxx_constexpr`| `-std=c++11`              |
| Compiler options          | `target_compile_options()`      |               | `-fPIC`                   |
| Compiler definitions      | `target_compile_definitions()`  |               | `-DSOMEDEF`               |
| Include directories       | `target_include_directories()`  |               | `-I/foo/bar`              |
| Link libraries            | `target_link_libraries()`       |               | `-l/path/to/library`      |
| Sources                   | `target_sources()`              |               |                           |

Example:
`target_compile_features(my_target PUBLIC cxx_constexpr)` will compile with a flag that enables the C++11 feature set.


### Use Public, Private, and Interface modes to scope the effect of target requirements
Modes define the scoping of the properties / requirements of a target. Kind of works like the distinction between public and private in a class.
* Who should this requirement concern?
    * Modes scope according to whether a requirement acts on interface, implementation, or both.
    * INTERFACE is for the header / interface only.
    * PRIVATE is for the binary / implementation only.
    * PUBLIC is for both the interface and the implementation.

Rationale:
* Consider a library consisting of a compiled binary (implementation) and a header (interface) 
* It might need one set of flags to compile the binary (the implementation), and another set of flags (perhaps a subset) in order to utilize or consume the header (the interface). Header-only libraries are not separately compiled, so whatever requirements are set will need to flow to any targets that depend on the header.


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

Example:
* `target_link_libraries(some_target another_target)`

Results:
* Link to `another_target`
* Determine build order
* Consume usage requirements
    * Compiling
    * Linking
* Determine compatibility


### Using namespaces for dependencies
Namespaces look like in C++. For example, a dependency for the Boost library `program_options` is typically referenced as `Boost::program_options`. This is useful for specifying library names and their components in an easy, portable way. Namespaces are actually "Alias libraries". See section "CMake Target types".

* A namespace is an alias library target. As such, it is a clarification / namespaced re-definition of a target (hence alias)
    * Declare it as:
        * `add_library(detail::platform_specific ALIAS platform_specific)`
    * Consume it as:
        * `target_link_libraries(mytarget detail::platform_specific)`

The advantage:
* Dependencies specified with `::` are interpreted as *definitely* being a CMake target, and so an error will *definitely* be thrown if it doesn't exists (i.e. it doesn't just delegate to the compiler to find a library somewhere).
* Most external libraries that are found using `find_library()` will provide such namespaced facilities. See section on external / system-wide libraries.


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

#### System installed/external libraries (-> SHARED or STATIC target types)
Use `find_package(<package_name> <version_number> EXACT COMPONENTS <component_names> REQUIRED)` to bring a package into scope, usually will give a library alias.

Example:
`find_package(Boost 1.40 COMPONENTS program_options REQUIRED)`. Reference using `Boost::program_options` afterwards.
* For Boost specifically: 
    * `Boost::boost` is target for header-only dependencies (i.e. the Boost include directory)
    * `Boost::named_component` is target for a specific component dependency (shared or static library)

Parameters:
`<package_name>`
* Packages supported by the installed version of CMake: type the command `cmake --help-module-list`
* The package handlers are located in the CMake library as `Find<package_name>.cmake` files.

`<version_number> EXACT` is optional
* State the minimum version of the package.
* State EXACT if exact version is needed.

`COMPONENT <component_name>` is optional
* The component name is the canonical name used in the library

`REQUIRED` is optional
* Will fail with error if the package is not found.
* Omit the keyword if the package is optional.


# CMake system

## The CMake object
CMake is declaration driven, rather than data-driven. A binary target in CMake is 

## CMake works in three phases
1. *Configure*: Parses the CMakeLists.txt file(s). Any if/else expressions are evaluated here. Variables are expanded during this phase.
2. *Compute*: Computes the dependencies. Generator expressions `$<bool:...>` are evaluated after this phase.
3. *Generate*: Makes the actual buildsystem files (Makefile, etc.)

## The CMake language
CMake has its own macro language (oh no, yet another language...). The commands in CMake are mostly _not_ expressions, so cannot be used as such.

### Selected features:
* `${variable_name}` expands / inserts the variable's value. Try to avoid using this in new projects.
* `if(condition)` / `elseif()` / `else()` / `endif()`
* `$<boolean:...>` generator expression is a conditional variable. These can be used inside commands. Examples:
    * `$<1:...>` will always return ...
    * `$<0:...>` will never return ...
    * `$<Config:Debug>` will return 1 in Debug config or 0 otherwise.
    * Can be nested: `$<$<Config:Debug>:...>` will return ... if in debug mode
    * Can use variables (variables are expanded in configure phase):
        * Configure phase: `$<$<BOOL:${WIN32}>: ...>` becomes
        * Generate phase: `$<$<BOOL:1>:...>` (true) or `$<$<BOOL:>...>` (false)
    * Read a property at generate time that is set at configure time:
        * `$<$<TARGET_PROPERTY:WITH_THREADS>:USE_THREADS>` could be used inside a command like target_compile_definitions(hello PRIVATE ...) and will reflect set_property(TARGET hello PROPERTY WITH_THREADS ON)

# Resources and inspiration
[0](https://cmake.org/cmake/help/v3.10/)
[1](https://github.com/Wigner-GPU-Lab/Teaching/tree/master/CMake/Lesson1_CompileC_CPP)
[2](https://github.com/onqtam/awesome-cmake)
[3](https://cmake.org/cmake/help/v3.10/manual/cmake-buildsystem.7.html)
[4](https://rix0r.nl/blog/2015/08/13/cmake-guide/)
[5](https://asmbits.blogspot.com/2017/06/idiomatic-cmake.html)
[6](https://www.slideshare.net/DanielPfeifer1/cmake-48475415)
[7](https://github.com/ttroy50/cmake-examples)
[8](https://www.youtube.com/watch?v=eC9-iRN2b04)
