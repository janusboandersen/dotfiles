
#Set up new Github repo for the current repo
gh-create() {
	#Usage: gh-create  repo-description repo-name user
	local CURRENTDIR=${PWD##*/}
	local REPONAME=${1:-${CURRENTDIR}}
	local DESCRIPTION=${2:-"To be added later"}
	local GITHUBUSER=${3:-"janusboandersen"} #$(git config github.user)
	#payload="{\"name\":\"${repo_name}\",\"description\":\"${repo_description}\"}"
	#echo "${payload}"
	#gh_api_cmd="curl -i -u janusboandersen -d '${payload}' https://api.github.com/user/repos" 
	#${gh_api_cmd}

	curl -u ${GITHUBUSER} https://api.github.com/user/repos -d "{\"name\": \"${REPONAME}\", \"description\": \"${DESCRIPTION}\", \"private\": false, \"has_issues\": true, \"has_downloads\": true, \"has_wiki\": false}"

	#git remote set-url origin git@github.com:${GITHUBUSER}/${REPONAME}.git
	#git push --set-upstream origin master

}
