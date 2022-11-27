#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
printf "${GREEN}Update go\n${NC}"
cd ~/Tools/
if [ ! -d update-golang ] 
then
	git clone https://github.com/udhos/update-golang
	cd update-golang
	sudo ./update-golang.sh
else
	printf "${RED}Folder already existed\n${NC}"
fi
printf "${GREEN}Installing Subfinder\n${NC}"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
printf "${GREEN}Installing Assetfinder\n${NC}"
go install -v github.com/tomnomnom/assetfinder@latest
printf "${GREEN}Installing Amass\n${NC}"
go install -v github.com/OWASP/Amass/v3/...@master
printf "${GREEN}Installing anew\n${NC}"
go install -v github.com/tomnomnom/anew@latest
printf "${GREEN}Installing httpx\n${NC}"
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
printf "${GREEN}Installing nuclei\n${NC}"
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
printf ${GREEN}"Installing cent\n${NC}"
GO111MODULE=on go install -v github.com/xm1k3/cent@latest
printf "${GREEN}Installing xray\n${NC}"
wget https://github.com/chaitin/xray/releases/download/1.9.3/xray_linux_amd64.zip -O ~/Downloads/xray_linux_amd64.zip
sudo unzip ~/Downloads/xray_linux_amd64.zip -d /usr/local/bin/

printf "${GREEN}Installing https://github.com/0xElkot/Bug-Bounty-Automation\n${NC}"
cd ~/Tools/
git clone https://github.com/0xElkot/Bug-Bounty-Automation
cd Bug-Bounty-Automation

sed 's/\/root/\~\/Documents/' 0xelkot.sh >> 0xelkot
rm 0xelkot.sh 
sudo ln -s ~/Tools/Bug-Bounty-Automation/0xelkot /usr/local/bin/bb-auto

printf "${GREEN}SET-UP is completed!\n${NC}"
