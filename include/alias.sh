# Insert aliases in addition to (that override) any from .zsh << .bash_profile

# Personal shortcuts
alias ws="cd ~/workspace"
alias wss="cd ~/workspace/study"
alias wsp="cd ~/workspace/projects"

# Set workdir stable over different processes
setworkdir () { echo "$(PWD)" > ~/.workdir }
gowork () { builtin cd "$(cat ~/.workdir)" }

# Listing related - only those that override or supplement Zsh
# Use a better ls for mac and set some nice settings for linux
#recursive for all other ls-related commands
case "$OSTYPE" in
	  solaris*) echo "SOLARIS LS" ;;
	  darwin*)  alias ls="gls --color=auto -F" ;; 
	  linux*)   alias ls="ls --color=auto -F" ;;
	  bsd*)     echo "BSD LS" ;;
	  msys*)    echo "WINDOWS LS" ;;
	  *)        echo "unknown LS: $OSTYPE" ;;
esac

alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'


# File system related
mkpath () { mkdir -p "$1" && cd "$1"; }


# Navigation
alias c='clear'
cdl() { builtin cd "$@"; l; }               # Always list directory contents upon 'cd'
alias cd..='cd ../'
alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'


# Environment overview 
alias path='echo -e ${PATH//:/\\n}'
alias edit='${EDITOR}'
alias e='${EDITOR}'
alias v='vim'

# Searching
alias qfind="find . -name "


# Networking
alias myip="curl ip.appspot.com"
alias tcpcons="lsof -i"                         #Show active TCP connections
alias openports="sudo lsof -i | grep LISTEN"    #Show all open ports


# Open URLs
url-open() {
    # Scipting for almost platform independent opening of URLs in their correct MIME handler
    if which open > /dev/null; then
        open "$@"                           # Mac OS
    elif which xdg-open > /dev/null; then
        xdg-open "$@"                       # Unix and some Linux desktops
    elif which gnome-open > /dev/null; then
        gnome-open "$@"                     # Older Gnome desktops
    elif which gvfs-open > /dev/null; then
        gvfs-open "$@"                      # Newer Gnome desktops
    else
        echo "Could not detect the web browser to use."
    fi
}
