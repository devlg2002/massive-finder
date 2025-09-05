# massive-finder

# MassiveFinder v1.0

Pipeline de enumeração de subdomínios com múltiplas ferramentas para reconhecimento de ativos.

## 🚀 Características

- Enumeração de subdomínios com múltiplas ferramentas
- Verificação de subdomínios ativos
- Suporte a API keys para fontes premium
- Relatórios automatizados
- Containerização com Docker
- Fácil instalação e uso

## 📦 Instalação Rápida

**Instalação com um comando:**

```bash
bash <(curl -s https://raw.githubusercontent.com/devlg2002/massive-finder/main/install.sh)
```

**Instalação Manual:**

```bash
git clone https://github.com/BackTrackSec/massivefinder.git
cd massivefinder
chmod +x install.sh
./install.sh
```

## 🛠️ Configuração

1. Edite o arquivo de configuração:
   ```bash
   cp config.env.example config.env
   nano config.env
   ```

2. Adicione suas API keys (opcional mas recomendado):
   - Chaos: https://chaos.projectdiscovery.io
   - Outras APIs: Veja [docs/API_KEYS.md](docs/API_KEYS.md)

## 🚀 Uso Básico

```bash
# Escanear um domínio
./massivefinder.sh example.com

# Escanear múltiplos domínios
./massivefinder.sh -f domains.txt

# Ver ajuda
./massivefinder.sh --help
```

## 🐳 Uso com Docker

```bash
# Construir imagem
docker build -t massivefinder .

# Executar
docker run -it --rm \
  -v $(pwd)/config.env:/app/config.env \
  -v $(pwd)/results:/app/results \
  massivefinder example.com
```

## 📊 Ferramentas Integradas

- [Subfinder](https://github.com/projectdiscovery/subfinder)
- [Amass](https://github.com/OWASP/Amass)
- [Assetfinder](https://github.com/tomnomnom/assetfinder)
- [Findomain](https://github.com/findomain/findomain)
- [HTTPX](https://github.com/projectdiscovery/httpx)
- [Chaos](https://chaos.projectdiscovery.io)

## 📝 Exemplos

Veja [docs/USAGE_EXAMPLES.md](docs/USAGE_EXAMPLES.md) para exemplos completos de uso.

## 🔒 Segurança

- Nunca commit arquivos de configuração com API keys
- Use variáveis de ambiente em ambientes CI/CD
- Revise as permissões das API keys regularmente

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para detalhes.

## ⚠️ Aviso Legal

Esta ferramenta é fornecida apenas para fins educacionais e de teste de penetração autorizado. Não use em sistemas sem permissão.

## 🐛 Reportar Bugs

Encontrou um bug? Por favor, abra uma issue no GitHub.

---

**Desenvolvido por devlg2002 - Co-CEO -> BackTrackSec** - (https://github.com/devlg2002)