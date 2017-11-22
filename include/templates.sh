# Defines functions that create templates on the fly in the shell
# Mostly directory structures

structure-cpp() {
    # Purpose: Build a C++ project directory structure    

    # Build the directory structure
    mkdir -p {archive,build,data,doc,deps,obj/{debug,release},src,test}

    # Insert your templates
    cp ${DOTFILES_TEMPLATE}/Makefile ./
    cp ${DOTFILES_TEMPLATE}/main.cpp ./src

}

structure-course() {
    # Purpose: Build a directory structure for coursework
    # Build the directory structure
    mkdir -p {archive,resources,data,coursework/{tutorials,lectures,assignments}}

    # Insert your templates
    echo 'url-open http://www.courseurl.com' >> source_me.sh
}
