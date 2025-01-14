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

#printf "${LIGHTBLUE}Copying Factorio Events Logger Mod to Server at ${LIGHTCYAN}dmz-user@192.168.86.62${NC}\n"
#scp -i ~/Home\ Lab/SSH\ Keys/proxmox-vms.pem ./build/events-logger_999.999.999.zip dmz-user@192.168.86.62:/home/dmz-user/. 2> /dev/null
printf "${LIGHTBLUE}Removing Factorio Events Logger Mod from Client at ${LIGHTCYAN}/c/Users/drahk/AppData/Roaming/Factorio/mods${NC}\n"
rm /c/Users/drahk/AppData/Roaming/Factorio/mods/events-logger_*.zip 2> /dev/null
printf "${LIGHTBLUE}Deploying Factorio Events Logger Mod to Client at ${LIGHTCYAN}/c/Users/drahk/AppData/Roaming/Factorio/mods${NC}\n"
cp ./build/events-logger_999.999.999.zip /c/Users/drahk/AppData/Roaming/Factorio/mods/. 2> /dev/null
#printf "${LIGHTBLUE}Removing Factorio Events Logger Mod from ${LIGHTCYAN}/opt/factorio/mods${NC}\n"
#ssh -i ~/Home\ Lab/SSH\ Keys/proxmox-vms.pem dmz-user@192.168.86.62 "sudo rm /opt/factorio/mods/events-logger_*.zip" 2> /dev/null
#printf "${LIGHTBLUE}Deploying Factorio Events Logger Mod to ${LIGHTCYAN}/opt/factorio/mods${NC}\n"
#ssh -i ~/Home\ Lab/SSH\ Keys/proxmox-vms.pem dmz-user@192.168.86.62 "sudo mv /home/dmz-user/events-logger_999.999.999.zip /opt/factorio/mods/." 2> /dev/null
#printf "${LIGHTBLUE}Setting ownership of Factorio Events Logger Mod to ${GREEN}factorio${NC}\n"
#ssh -i ~/Home\ Lab/SSH\ Keys/proxmox-vms.pem dmz-user@192.168.86.62 "sudo chown factorio: /opt/factorio/mods/events-logger_999.999.999.zip" 2> /dev/null
#printf "${LIGHTBLUE}Restarting Factorio Server${NC}\n"
#ssh -i ~/Home\ Lab/SSH\ Keys/proxmox-vms.pem dmz-user@192.168.86.62 "sudo systemctl stop factorio ; sleep 3 ; sudo systemctl start factorio" 2> /dev/null
rm -rf ./build
printf "${LIGHTGREEN}Deployment Complete${NC}\n"