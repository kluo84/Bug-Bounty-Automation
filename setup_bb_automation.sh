#!/bin/bash

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Function to print a message in green
function echo_green() {
    printf "${GREEN}$1${NC}\n"
}

# Function to print a message in red
function echo_red() {
    printf "${RED}$1${NC}\n"
}

# Check and Install go
echo_green "Checking and Installing Go"
if ! command -v go &>/dev/null; then
    sudo apt install golang-go -y
else
    echo_red "Go is already installed"
fi

# Add /go/bin to PATH in .zshrc and .bashrc
echo_green "Checking and adding /go/bin to PATH in .zshrc and .bashrc"

declare -a shells=(~/.zshrc ~/.bashrc)

for shell_rc in "${shells[@]}"; do
    if [[ -f $shell_rc ]]; then
        if ! grep -Fxq "export PATH=$PATH:~/go/bin" $shell_rc; then
            echo 'export PATH=$PATH:~/go/bin' >> $shell_rc
            source $shell_rc
            echo_green "Added /go/bin to $shell_rc"
        else
            echo_red "/go/bin is already in $shell_rc"
        fi
    else
        echo_red "$shell_rc file not found"
    fi
done

# Update go
echo_green "Updating Go"
cd ~/Tools/
if [ ! -d update-golang ]; then
    git clone https://github.com/udhos/update-golang
    cd update-golang
    sudo ./update-golang.sh
else
    echo_red "update-golang folder already exists"
fi

# Installations
declare -A tools=(
    ["subfinder"]="github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    ["assetfinder"]="github.com/tomnomnom/assetfinder@latest"
    ["amass"]="github.com/OWASP/Amass/v3/...@master"
    ["anew"]="github.com/tomnomnom/anew@latest"
    ["httpx"]="github.com/projectdiscovery/httpx/cmd/httpx@latest"
    ["katana"]="github.com/projectdiscovery/katana/cmd/katana@latest"
    ["gf"]="github.com/tomnomnom/gf@latest"
    ["gau"]="github.com/lc/gau/v2/cmd/gau@latest"
    ["qsreplace"]="github.com/tomnomnom/qsreplace@latest"
    ["jsubfinder"]="github.com/ThreatUnkown/jsubfinder@latest"
    ["dalfox"]="github.com/hahwul/dalfox/v2@latest"
    ["ffuf"]="github.com/ffuf/ffuf@latest"
    ["naabu"]="github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
    ["nuclei"]="github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
    ["cent"]="github.com/xm1k3/cent@latest"
)

for tool in "${!tools[@]}"; do
    echo_green "Installing $tool"
    go install -v "${tools[$tool]}"
done

# Other installations and configurations
echo_green "Installing GF-Patterns"
git clone https://github.com/1ndianl33t/Gf-Patterns ~/Tools/
mkdir -p ~/.gf
mv ~/Tools/Gf-Patterns/*.json ~/.gf

# ... Add other installations similar to above ...

echo_green "Initializing nuclei templates via cent and downloading assetnote wordlists"
cd ~/Documents/
cent init
cent -p cent-nuclei-templates -k
cd ~/Tools
wget -r --no-parent -R "index.html*" https://wordlists-cdn.assetnote.io/data/ -nH

echo_green "SET-UP is completed!"
