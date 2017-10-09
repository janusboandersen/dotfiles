g-copy() {
	#Usage g-copy <file-to-copy> <*dir-to-paste-in>
	#Inserts a git-related setting or file from the dotfiles into the current directory
	#Requires that the shell is set up with a $DOTFILES variable
	local SOURCEFILE=${1:-readme.md}
	local SOURCEDIR=${DOTFILES:-"${HOME}/.dotfiles"}
	local PASTEDIR=${2:-"."}
	cp "${SOURCEDIR}/git/${SOURCEFILE}" "${PASTEDIR}"
}

g-ignore() {
	#Inserts gitignore
	g-copy ".gitignore"
}

g-readme() {
	#Inserts readme
	g-copy "readme.md"
}

gh-create() {
	#Init a new local repo, sets up new Github remote repo for the current local repo, and link them.
	#Inserts the stock .gitignore for good measure
	#Usage: gh-create  <repo-description> <repo-name> <github-user>
	local CURRENTDIR=${PWD##*/}
	local REPONAME=${2:-${CURRENTDIR}}
	local DESCRIPTION=${1:-"${REPONAME}"}
	local GITUSER=${GITUSERNAME:-"janusboandersen"} #Tries to get the GIT user from the shell or defaults to janusboandersen
	local GITHUBUSER=${3:-"${GITUSER}"} #Use what the function caller supplied or use the shell/default

	git init

	curl --silent -u ${GITHUBUSER} -o /dev/null https://api.github.com/user/repos -d "{\"name\": \"${REPONAME}\", \"description\": \"${DESCRIPTION}\", \"private\": false, \"has_issues\": true, \"has_downloads\": true, \"has_wiki\": false}"

	git remote add origin git@github.com:${GITHUBUSER}/${REPONAME}.git
	g-ignore && g-readme
	git add -A && git commit -m "Set up repo"
	git push --set-upstream origin master

}
