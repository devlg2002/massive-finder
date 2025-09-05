#!/bin/bash

# MassiveFinder Installation Script
set -e

echo -e "\033[1;34m"
cat << 'EOF'
#88b           d88                                88
#888b         d888                                ""
#88`8b       d8'88
#88 `8b     d8' 88 ,adPPYYba, ,adPPYba, ,adPPYba, 88 8b       d8  ,adPPYba,
#88  `8b   d8'  88 ""     `Y8 I8[    "" I8[    "" 88 `8b     d8' a8P_____88
#88   `8b d8'   88 ,adPPPPP88  ``Y8ba,   ``Y8ba,  88  `8b   d8'  8PP```````
#88    `888'    88 88,    ,88 aa    ]8I aa    ]8I 88   `8b,d8'   `8b,   ,aa
#88     `8'     88 ``8bbdP`Y8 ``YbbdP`' ``YbbdP`' 88     `8`      ``Ybbd8`' 
                                                                           
#88888888888 88                      88
#88          ""                      88
#88                                  88
#88aaaaa     88 8b,dPPYba,   ,adPPYb,88  ,adPPYba, 8b,dPPYba,
#88`````     88 88P'   ``8a a8`    `Y88 a8P_____88 88P'   `Y8
#88          88 88       88 8b       88 8PP``````` 88
#88          88 88       88 `8a,   ,d88 `8b,   ,aa 88
#88          88 88       88  ``8bbdP`Y8  ``Ybbd8`' 88
EOF
echo -e "\033[0m"

echo -e "\033[1;36mMassiveFinder v1.0 - By @devlg2002 - BackTrackSec\033[0m"
echo -e "\033[1;33mSubdomain Enumeration Pipeline - Installation\033[0m"
echo "============================================="

# Verificar se é root
if [ "$EUID" -eq 0 ]; then
    echo -e "\033[1;31m[!] Não execute este script como root!\033[0m"
    exit 1
fi

# Verificar dependências básicas
echo -e "\033[1;34m[+] Verificando dependências básicas...\033[0m"
for cmd in git curl wget; do
    if ! command -v "$cmd" &> /dev/null; then
        echo -e "\033[1;31m[!] $cmd não encontrado. Instalando...\033[0m"
        sudo apt-get update && sudo apt-get install -y "$cmd"
    fi
done

# Clonar repositório se necessário
if [ ! -d "massive-finder" ]; then
    echo -e "\033[1;34m[+] Clonando repositório...\033[0m"
    git clone https://github.com/devlg2002/massive-finder.git
fi

cd massive-finder

# Instalar dependências do sistema
echo -e "\033[1;34m[+] Instalando dependências do sistema...\033[0m"
sudo apt-get update && sudo apt-get install -y \
    git curl wget jq python3 python3-pip docker.io docker-compose

# Instalar ferramentas
echo -e "\033[1;34m[+] Instalando ferramentas de reconhecimento...\033[0m"
chmod +x tools/install_tools.sh
./tools/install_tools.sh

# Configurar ambiente
if [ ! -f config.env ]; then
    cp config.env.example config.env
    echo -e "\033[1;33m[!] Por favor, edite o arquivo config.env e adicione suas API keys\033[0m"
    echo -e "\033[1;33m[!] Documentação disponível em docs/API_KEYS.md\033[0m"
fi

# Tornar o script principal executável
chmod +x massive-finder.sh

# Configurar alias no bashrc
if ! grep -q "alias massive-finder" ~/.bashrc; then
    echo "alias massive-finder='$(pwd)/massive-finder.sh'" >> ~/.zshrc
    echo -e "\033[1;34m[+] Alias 'massivefinder' adicionado ao ~/.zshrc\033[0m"
    echo -e "\033[1;33m[!] Execute 'source ~/.zshrc' ou reinicie o terminal\033[0m"
fi

echo -e "\033[1;32m[+] Instalação completa!\033[0m"
echo -e "\033[1;33m[+] Próximos passos:\033[0m"
echo -e "  1. Edite config.env com suas API keys"
echo -e "  2. Execute: massivefinder example.com"
echo -e "  3. Ou consulte: docs/USAGE_EXAMPLES.md"