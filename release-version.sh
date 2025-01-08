#!/usr/bin/env bash

RED='\033[0;31m'
LIGHTRED='\033[1;31m'
GREEN='\033[0;32m'
LIGHTGREEN='\033[1;32m'
BROWN='\033[0;33m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
LIGHTBLUE='\033[1;34m'
CYAN='\033[0;36m'
LIGHTCYAN='\033[1;36m'
PURPLE='\033[0;35m'
LIGHTPURPLE='\033[1;35m'
DARKGRAY='\033[1;30m'
LIGHTGRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m'

function join_by {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}


# Variables
REPO_OWNER="Ralnoc"
REPO_NAME="events-logger"
PR_BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)

# GitHub API URL
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/pulls"

# Make the API request
response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$API_URL")

# Find the PR for the branch
pr=$(echo "$response" | jq --arg branch "${PR_BRANCH}" '.[] | select(.head.ref == $branch)')

# Check if the PR exists
if [ -z "$pr" ]; then
  printf "${LIGHTRED}No ${LIGHTGRAY}open${LIGHTRED} PR found for branch ${YELLOW}${PR_BRANCH}${NC}\n"
  exit 0
fi

# Extract PR details
pr_number=$(echo "$pr" | jq '.number')
mergeable_state=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/pulls/$pr_number" | jq -r '.mergeable_state')

set -e
# Display the PR status
printf "${LIGHTBLUE}PR Branch ${YELLOW}${PR_BRANCH}${LIGHTGREEN} has an open PR ${WHITE}(${LIGHTPURPLE}#${pr_number}${WHITE})${NC}\n"
printf "${LIGHTBLUE}Mergeable State: ${LIGHTGREEN}${mergeable_state}${NC}\n"

printf "${LIGHTBLUE}Evaluating Version Information${NC}\n"
R_MASTER_VERSION=$(git tag -l -n0 --points-at main 2> /dev/null)
printf "${LIGHTBLUE}Latest Tag: $R_MASTER_VERSION${NC}\n"
IFS='.' read -ra OCTET <<< "$R_MASTER_VERSION"
VERSION_OCTETS=()
for i in "${OCTET[@]}"; do
  VERSION_OCTETS+=( "$i" )
done
VERSION_OCTETS[2]=$((VERSION_OCTETS[2] + 1))
RELEASE_VERSION=$(join_by . "${VERSION_OCTETS[@]}")
printf "${LIGHTBLUE}Release Version: $RELEASE_VERSION${NC}\n"

printf "${LIGHTBLUE}Fetching Origin${NC}\n"
git fetch origin 2> /dev/null
NUM_COMMITS_IN_PR=$(git log --count --oneline --cherry remotes/origin/main...remotes/origin/${PR_BRANCH} 2> /dev/null | wc -l)
COMMITS=$(git log --oneline remotes/origin/main...remotes/origin/${PR_BRANCH} 2> /dev/null)
MAIN_NUM_BEHIND=$(git rev-list --left-right --count main..origin/main 2> /dev/null | awk '{print $1}')
printf "${LIGHTBLUE}PR has ${YELLOW}${NUM_COMMITS_IN_PR}${LIGHTBLUE} commits since ${R_MASTER_VERSION}${NC}\n"
printf "${LIGHTBLUE}Main is ${YELLOW}${MAIN_NUM_BEHIND}${LIGHTBLUE} commits behind origin/main${NC}\n"
printf "${LIGHTBLUE}Commits:\n${YELLOW}${COMMITS}${NC}\n"

echo ""
if [ "${NUM_COMMITS_IN_PR}" -ne 0 ]; then
  printf "${LIGHTGREEN}Verified ${YELLOW}origin/${PR_BRANCH}${LIGHTGREEN} has not been rebased into ${LIGHTCYAN}origin/main${NC}\n"
else
  printf "${LIGHTRED}PR Branch has no commits different than ${YELLOW}origin/main${NC}\n"
  exit 1
fi
if [ "${MAIN_NUM_BEHIND}" -lt 1 ]; then
  printf "${LIGHTGREEN}The branch ${YELLOW}origin/${PR_BRANCH}${LIGHTGREEN} is ready to merge.${NC}\n"
else
  printf "${LIGHTRED}The branch ${YELLOW}origin/${PR_BRANCH} is NOT ready to merge.${NC}\n"
  printf "It is behind ${YELLOW}origin/main${LIGHTRED} by ${YELLOW}${MAIN_NUM_BEHIND}${LIGHTRED} commits.${NC}\n"
  exit 1
fi
if [ "$mergeable_state" == "clean" ]; then
  printf "${LIGHTGREEN}The PR is ready to merge.${NC}\n"
else
  printf "${LIGHTRED}The PR is NOT ready to merge. Mergeable state: ${YELLOW}${mergeable_state}${NC}\n"
  exit 1
fi

printf "${LIGHTBLUE}Updating ${PR_BRANCH} from origin${NC}\n"
git pull origin ${PR_BRANCH} --tags 2> /dev/null
printf "${LIGHTBLUE}Checking out main${NC}\n"
git checkout main 2> /dev/null
printf "${LIGHTBLUE}Pulling main from origin${NC}\n"
git pull origin main --tags 2> /dev/null
printf "${LIGHTBLUE}Rebasing ${PR_BRANCH} into main${NC}\n"
git rebase ${PR_BRANCH} main 2> /dev/null

echo ""
printf "${LIGHTBLUE}Tagging Release Version ${PURPLE}${RELEASE_VERSION}${NC}\n"
git tag -a ${RELEASE_VERSION} -m "Release Version ${RELEASE_VERSION}" 2> /dev/null
printf "${LIGHTBLUE}Pushing tags to Origin${NC}\n"
git push origin main --tags 2> /dev/null

