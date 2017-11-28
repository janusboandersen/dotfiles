# The idea behind CMake is to help you reason about modules and dependencies instead of compiler flags
CMake is a generator to create a build system (Makefile, Ninja, etc.). 
Let CMake take control of deciding when you need which flags, and instead focus on which modules are needed for your code. You define your project in terms of modular elements (= targets), their dependencies, and the settings they need in order to work (= properties). 

## Setting up a Modern CMake project: Guidelines
Do: 
* Work (and think) with targets and properties.
* ...

Don't: 
* Use functions that work directly on the directory structure:
    * Use these: `add_compile_options()`, `include_directories()`, `link_directories()`, `link_libraries()`.
    * Use variables and globbing directly in the code (that should only be in the Makefile)

## Bring all required elements into scope
Your project has its own CMake file. External libraries/modules that you depend on (system installed) or in your project repo, should be brought into scope for CMake to be aware of them.

### System installed libraries
Use `find_package()` to bring these into scope, e.g. `find_package(Boost REQUIRED)`.

### Libraries in your repo
These will hopefully have their own CMake file, and are brought into scope by ??? `add_subdirectory` or `add_library`??

`target_link_library`
`project`

