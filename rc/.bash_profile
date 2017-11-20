# Get absolute resolved paths for the dotfiles directories
export DOTFILES_RC="$(dirname "$(readlink "$0")")"
export DOTFILES="$(cd $DOTFILES_RC/.. && pwd)"
export DOTFILES_INCLUDE="${DOTFILES}/include"
export DOTFILES_TEMPLATE="${DOTFILES}/template"

# Include all files from include directory
for f in $DOTFILES_INCLUDE/*; do
    source $f
done
