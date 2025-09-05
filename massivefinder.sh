#!/bin/bash

# MassiveFinder v1.0 -@devlg2002 By BackTrackSec
# Pipeline de enumeração de subdomínios

# Configurações padrão
CONFIG_FILE="$(dirname "$0")/config.env"
TOOLSDIR="$HOME/tools"
DATE=$(date +"%Y%m%d_%H%M%S")
DEFAULT_WORDLIST="$TOOLSDIR/wordlists/subdomains.txt"

# Carregar configurações
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        echo -e "\033[1;32m[+] Configuração carregada de $CONFIG_FILE\033[0m"
    else
        echo -e "\033[1;33m[!] Arquivo de configuração não encontrado. Usando padrões.\033[0m"
        echo -e "\033[1;33m[!] Execute o install.sh ou crie um config.env\033[0m"
    fi
    
    # Verificar API key do Chaos
    if [ -z "$CHAOS_API_KEY" ] || [ "$CHAOS_API_KEY" = "your_chaos_api_key_here" ]; then
        echo -e "\033[1;33m[!] Chaos API key não configurada. Algumas funcionalidades estarão limitadas.\033[0m"
        echo -e "\033[1;33m[!] Obtenha uma em: https://chaos.projectdiscovery.io\033[0m"
    fi
}

# Banner colorido
show_banner() {
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
    echo -e "\033[1;33mSubdomain Enumeration Pipeline\033[0m"
    echo -e "\033[1;32m$(date)\033[0m"
    echo "============================================="
    echo
}

# Verificar e instalar dependências
check_dependencies() {
    local deps=("subfinder" "amass" "assetfinder" "findomain" "httpx" "anew" "jq")
    local missing=()

    echo -e "\033[1;34m[+] Verificando dependências...\033[0m"

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
            echo -e "  \033[1;31m[-] $dep não encontrado\033[0m"
        else
            echo -e "  \033[1;32m[+] $dep encontrado\033[0m"
        fi
    done

    # Verificar chaos-client separadamente (pode não estar instalado)
    if ! command -v chaos &> /dev/null; then
        echo -e "  \033[1;33m[!] chaos-client não encontrado (opcional)\033[0m"
    else
        echo -e "  \033[1;32m[+] chaos-client encontrado\033[0m"
    fi

    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "\033[1;31m[!] Algumas dependências estão faltando.\033[0m"
        echo -e "\033[1;33m[!] Execute ./tools/install_tools.sh para instalá-las\033[0m"
        read -p "Deseja instalar agora? (s/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            ./tools/install_tools.sh
        else
            exit 1
        fi
    fi
}

# Função principal de enumeração
run_recon() {
    local target="$1"
    local output_dir="recon_${target}_${DATE}"

    echo -e "\033[1;34m[+] Iniciando reconhecimento para: \033[1;32m$target\033[0m"
    echo -e "\033[1;34m[+] Criando diretório de saída: \033[1;32m$output_dir\033[0m"

    mkdir -p "$output_dir"
    cd "$output_dir" || exit

    # Subfinder
    echo -e "\033[1;34m[+] Executando Subfinder...\033[0m"
    subfinder -d "$target" -silent -o subfinder.txt

    # Amass
    echo -e "\033[1;34m[+] Executando Amass (passivo)...\033[0m"
    amass enum -passive -d "$target" -o amass.txt

    # Assetfinder
    echo -e "\033[1;34m[+] Executando Assetfinder...\033[0m"
    assetfinder --subs-only "$target" | anew assetfinder.txt

    # Findomain
    echo -e "\033[1;34m[+] Executando Findomain...\033[0m"
    findomain -t "$target" -u findomain.txt

    # Cert.sh
    echo -e "\033[1;34m[+] Executando Cert.sh...\033[0m"
    curl -s "https://crt.sh/?q=%25.$target&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | anew certsh.txt

    # Chaos (apenas se API key estiver configurada)
    if command -v chaos &> /dev/null && [ -n "$CHAOS_API_KEY" ] && [ "$CHAOS_API_KEY" != "your_chaos_api_key_here" ]; then
        echo -e "\033[1;34m[+] Executando Chaos...\033[0m"
        chaos -d "$target" -key "$CHAOS_API_KEY" -o chaos.txt
    else
        echo -e "\033[1;33m[!] Pulando Chaos (não configurado)\033[0m"
    fi

    # Combinar resultados
    echo -e "\033[1;34m[+] Combinando resultados...\033[0m"
    cat *.txt 2>/dev/null | sort -u > "all_subdomains_$target.txt"

    # Verificar se há subdomínios encontrados
    if [ ! -s "all_subdomains_$target.txt" ]; then
        echo -e "\033[1;31m[!] Nenhum subdomínio encontrado para $target\033[0m"
        cd ..
        rm -rf "$output_dir"
        return 1
    fi

    # Verificar subdomínios ativos
    echo -e "\033[1;34m[+] Verificando subdomínios ativos com HTTProbe...\033[0m"
    httpx -l "all_subdomains_$target.txt" -title -status-code -tech-detect -o "active_subdomains_$target.txt"

    # Resultados
    local total_subs=$(wc -l < "all_subdomains_$target.txt")
    local active_subs=$(wc -l < "active_subdomains_$target.txt")

    echo -e "\033[1;32m[+] Reconhecimento completo!\033[0m"
    echo -e "\033[1;33m[+] Total de subdomínios encontrados: \033[1;36m$total_subs\033[0m"
    echo -e "\033[1;33m[+] Total de subdomínios ativos: \033[1;36m$active_subs\033[0m"
    echo -e "\033[1;33m[+] Resultados salvos em: \033[1;36m$output_dir\033[0m"

    # Gerar relatório resumido
    generate_report "$target" "$total_subs" "$active_subs"
    
    cd ..
}

# Gerar relatório resumido
generate_report() {
    local target="$1"
    local total="$2"
    local active="$3"
    
    cat > "REPORT.md" << EOF
# MassiveFinder Report
- **Target**: $target
- **Date**: $(date)
- **Total Subdomains**: $total
- **Active Subdomains**: $active

## Comandos Executados
- Subfinder
- Amass (passive)
- Assetfinder
- Findomain
- Cert.sh
- Chaos (optional)
- HTTPX

## Result Files
- all_subdomains_$target.txt - All discovered subdomains
- active_subdomains_$target.txt - Active subdomains with HTTP details

## Notas
Relatório gerado automaticamente por MassiveFinder v1.0
EOF
}

# Mostrar uso
show_usage() {
    echo -e "\033[1;33mUso:\033[0m"
    echo -e "  $0 <domínio>                 # Escanear um único domínio"
    echo -e "  $0 -f <arquivo>              # Escanear múltiplos domínios de um arquivo"
    echo -e "  $0 -d <domínio> -o <dir>     # Especificar domínio e diretório de saída"
    echo -e "  $0 --help                    # Mostrar esta ajuda"
    echo
    echo -e "\033[1;33mExemplos:\033[0m"
    echo -e "  $0 example.com"
    echo -e "  $0 -f domains.txt"
    echo -e "  $0 -d example.com -o my_scan"
}

# Main
main() {
    local target=""
    local file=""
    local output_dir=""
    
    load_config
    show_banner
    
    # Verificar se não há argumentos
    if [ $# -eq 0 ]; then
        show_usage
        exit 1
    fi
    
    # Processar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--domain)
                target="$2"
                shift 2
                ;;
            -f|--file)
                file="$2"
                shift 2
                ;;
            -o|--output)
                output_dir="$2"
                shift 2
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                # Assume que é um domínio se não começar com -
                if [[ "$1" != -* ]]; then
                    target="$1"
                fi
                shift
                ;;
        esac
    done

    check_dependencies

    # Verificar se o output_dir foi especificado
    if [ -n "$output_dir" ]; then
        mkdir -p "$output_dir"
        cd "$output_dir" || exit
    fi

    if [ -n "$file" ] && [ -f "$file" ]; then
        echo -e "\033[1;34m[+] Processando arquivo de domínios: \033[1;32m$file\033[0m"
        while IFS= read -r domain || [ -n "$domain" ]; do
            # Pular linhas vazias e comentários
            if [[ -z "$domain" || "$domain" =~ ^# ]]; then
                continue
            fi
            run_recon "$domain"
        done < "$file"
    elif [ -n "$target" ]; then
        run_recon "$target"
    else
        echo -e "\033[1;31m[!] Domínio ou arquivo não especificado\033[0m"
        show_usage
        exit 1
    fi
}

main "$@"