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

rm -rf ./build/files
mkdir -p ./build/files
printf "${LIGHTBLUE}Copying Factorio Events Logger Mod build files to build directory${NC}\n"
for filename in control.lua info.json LICENSE.md logger.lua README.md thumbnail.png; do
  cp ${filename} build/files/.
done
printf "${LIGHTBLUE}Updating Version to Test Version${NC}\n"
sed -i "s/@@VERSION@@/0.0.999/g" build/files/info.json