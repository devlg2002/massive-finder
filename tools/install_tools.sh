#!/bin/bash

# MassiveFinder Tools Installation Script

echo -e "\033[1;34m[+] Instalando ferramentas para o MassiveFinder...\033[0m"

# Criar diretório de ferramentas
mkdir -p "$HOME/tools"
mkdir -p "$HOME/tools/wordlists"

# Instalar Go se não existir
if ! command -v go &> /dev/null; then
    echo -e "\033[1;34m[+] Instalando Go...\033[0m"
    wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz -O /tmp/go.tar.gz
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    export PATH=$PATH:/usr/local/go/bin
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    source ~/.bashrc
    rm /tmp/go.tar.gz
fi

# Configurar Go path
export GOPATH="$HOME/go"
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# Instalar ferramentas Go
echo -e "\033[1;34m[+] Instalando ferramentas Go...\033[0m"

go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/owasp-amass/amass/v3/...@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/projectdiscovery/chaos-client/cmd/chaos@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/tomnomnom/anew@latest

# Instalar Findomain (Rust)
echo -e "\033[1;34m[+] Instalando Findomain...\033[0m"
wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux -O /tmp/findomain
chmod +x /tmp/findomain
sudo mv /tmp/findomain /usr/local/bin/findomain

# Baixar wordlists
echo -e "\033[1;34m[+] Baixando wordlists...\033[0m"
wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt -O "$HOME/tools/wordlists/subdomains.txt"

# Mover binários para PATH
sudo cp ~/go/bin/* /usr/local/bin/ 2>/dev/null || true

echo -e "\033[1;32m[+] Instalação de ferramentas concluída!\033[0m"