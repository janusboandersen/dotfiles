# Defines functions that create templates on the fly in the shell
# Mostly directory structures

s-cpp() {
    mkdir -p {archive,build,data,doc,deps,obj/{debug,release},src,test}
    cp ${DOTFILES_TEMPLATE}/Makefile ./
    cp ${DOTFILES_TEMPLATE}/main.cpp ./src

}
