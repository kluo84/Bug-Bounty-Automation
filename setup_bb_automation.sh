#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

printf "${GREEN}Install go\n${NC}"
sudo apt install golang-go -y

printf "${GREEN} Add /go/bin to PATH\n${NC}"

if grep -Fxq "export PATH=$PATH:~/go/bin" ~/.zshrc
then
	printf("${RED}/go/bin already exist in zshrc file ${NC}")
else
	echo 'export PATH=$PATH:~/go/bin' >> ~/.zshrc
fi
source ~/.zshrc

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

printf "${GREEN}Installing Katana\n${NC}"
go install github.com/projectdiscovery/katana/cmd/katana@latest
printf "${GREEN}Installing GF\n${NC}"
go install -v github.com/tomnomnom/gf@latest
printf "${GREEN}Installing GF-Patterns\n${NC}"
git clone https://github.com/1ndianl33t/Gf-Patterns ~/Tools/
mkdir ~/.gf
mv ~/Tools/Gf-Patterns/*.json ~/.gf

printf "${GREEN}Installing CloudFlair\n${NC}"
git clone https://github.com/christophetd/cloudflair.git ~/Tools/
pip3 install -r ~/Tools/cloudflair/requirements.txt

printf "${GREEN}Installing Gau\n${NC}"
go install github.com/lc/gau/v2/cmd/gau@latest

printf "${GREEN}Installing QSreplace\n${NC}"
go install github.com/tomnomnom/qsreplace@latest

printf "${GREEN}Installing URO and Arjun\n${NC}"
pip3 install uro
pip3 install arjun

printf "${GREEN}Installing jsubfinder\n${NC}"
go install github.com/ThreatUnkown/jsubfinder@latest
wget https://raw.githubusercontent.com/ThreatUnkown/jsubfinder/master/.jsf_signatures.yaml && mv .jsf_signatures.yaml ~/.jsf_signatures.yaml

printf "${GREEN}Installing Dalfox\n${NC}"
go install github.com/hahwul/dalfox/v2@latest
printf "${GREEN}Installing ffuf\n${NC}"
go install github.com/ffuf/ffuf@latest

printf "${GREEN}Installing altdns\n${NC}"
git clone https://github.com/infosec-au/altdns ~/Tools
pip3 install -r ~/Tools/altdns/requirements.txt
python3 ~/Tools/altdns/setup.py install

printf "${GREEN}Installing DNSReaper\n${NC}"
git clone https://github.com/punk-security/dnsReaper ~/Tools/
pip3 install -r ~/Tools/dnsReaper/requirements.txt

printf "${GREEN}Installing nuclei\n${NC}"
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
printf ${GREEN}"Installing cent\n${NC}"
GO111MODULE=on go install -v github.com/xm1k3/cent@latest
printf "${GREEN}Installing xray\n${NC}"
wget https://github.com/chaitin/xray/releases/download/1.9.3/xray_linux_amd64.zip -O ~/Downloads/xray_linux_amd64.zip
sudo unzip ~/Downloads/xray_linux_amd64.zip -d /usr/local/bin/

printf "${GREEN}Inititalizing nuclei templates via cent and download assetnote wordlists\n${NC}"
cd ~/Documents/
cent init
cent -p cent-nuclei-templates -k
cd ~/Tools
wget -r --no-parent -R "index.html*" https://wordlists-cdn.assetnote.io/data/ -nH
printf "${GREEN}SET-UP is completed!\n${NC}"
