# Defines functions that create templates on the fly in the shell
# Mostly directory structures

structure-cpp() {
    # Purpose: Build a C++ project directory structure    
    # Attempts to be aligned with the GNU C++ directory structure

    # Build the directory structure
    mkdir -p {archive,build,data,doc,deps,include,obj/{debug,release},src/{c++11,shared},test}

    # Insert your templates
    cp ${DOTFILES_TEMPLATE}/Makefile ./
    cp ${DOTFILES_TEMPLATE}/main.cpp ./src/c++11

}

structure-course() {
    # Purpose: Build a directory structure for coursework
    # Build the directory structure
    mkdir -p {archive,resources,data,coursework/{tutorials,lectures,assignments}}

    # Insert your templates
    echo 'url-open http://www.courseurl.com' >> source_me.sh
}
