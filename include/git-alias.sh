g-copy() {
	#Usage g-copy <file-to-copy> <*dir-to-paste-in>
	#Inserts a git-related setting or file from the dotfiles into the current directory
	#Requires that the shell is set up with a $DOTFILES variable
	local SOURCEFILE=${1:-readme.md}
	local SOURCEDIR=${DOTFILES:-"${HOME}/dotfiles"}
	local PASTEDIR=${2:-"."}
	cp "${SOURCEDIR}/template/${SOURCEFILE}" "${PASTEDIR}"
}

g-ignore() {
	#Inserts gitignore
	g-copy ".gitignore"
}

g-readme() {
	#Inserts readme
	g-copy "readme.md"
}

g-license() {
	#Inserts license
	g-copy "LICENSE"
}
gh-create() {
	#Init a new local repo, sets up new Github remote repo for the current local repo, and link them.
	#Inserts the stock .gitignore for good measure
	#Usage: gh-create  <repo-description> <repo-name> <github-user>
	local CURRENTDIR=${PWD##*/}
	local REPONAME=${2:-${CURRENTDIR}}
	local DESCRIPTION=${1:-"${REPONAME}"}
	local GITHUBACCOUNT=${GITHUBUSERNAME:-"$(git config --global github.user)"} #Tries to get the GITHUB username from the shell or then attempts to get it from config
	local GITHUBUSER=${3:-"${GITHUBACCOUNT}"} #Use what the function caller supplied or use the shell/config

	git init

	curl --silent -u ${GITHUBUSER} -o /dev/null https://api.github.com/user/repos -d "{\"name\": \"${REPONAME}\", \"description\": \"${DESCRIPTION}\", \"private\": false, \"has_issues\": true, \"has_downloads\": true, \"has_wiki\": false}"

	git remote add origin git@github.com:${GITHUBUSER}/${REPONAME}.git
	g-ignore && g-readme && g-license
	git add -A && git commit -m "Set up repo"
	git push --set-upstream origin master

}
