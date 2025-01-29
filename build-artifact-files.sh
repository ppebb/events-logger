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

MOD_NAME="events-logger"
BUILD_DIR="./build/files/${MOD_NAME}"
ADDITIONAL_FILES="LICENSE.md locale events custom_events"

rm -rf ./build/files
mkdir -p ./build/files
mkdir -p ${BUILD_DIR}

printf "${LIGHTBLUE}Copying ${YELLOW}${MOD_NAME}${LIGHTBLUE} build files to ${LIGHTGRAY}${BUILD_DIR}${NC}\n"
for filename in *.lua info.json *.png README.md ${ADDITIONAL_FILES}  ; do
  cp -r ./${filename} ${BUILD_DIR}/.
done