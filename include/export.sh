# Exports to the shell

# ---------------------------
# Control the environment
# ---------------------------

# Set my favorite editor
export EDITOR=vim

# Set the locale, encoding, etc.
export LC_ALL=da_DK.UTF-8
export LANG=da_DK.UTF-8

# Exports the LS_COLORS which is used by GNU LS (gls on mac with coreutils)

case "$OSTYPE" in
	  solaris*) echo "SOLARIS" ;;
	  darwin*)  eval `gdircolors ${HOME}/.dircolors` ;; 
	  linux*)   eval `dircolors ${HOME}/.dircolors` ;;
      bsd*)     echo "BSD" ;;
	  msys*)    echo "WINDOWS" ;;
      *)        echo "unknown: $OSTYPE" ;;
esac

# if [["$OSTYPE"="Darwin"]]; then eval `gdircolors ${HOME}/.dircolors`; fi


