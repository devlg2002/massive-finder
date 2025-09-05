# Exemplos de Uso do MassiveFinder

## Escaneamento Básico

```bash
# Escanear um único domínio
./massive-finder.sh example.com

# Escanear múltiplos domínios de um arquivo
./massive-finder.sh -f domains.txt

# Especificar diretório de saída
./massive-finder.sh -d example.com -o my_scan_results
```

## Uso com Docker

```bash
# Construir a imagem
docker build -f docker/Dockerfile -t massive-finder .

# Executar escaneamento
docker run -it --rm \
  -v $(pwd)/config.env:/app/config.env \
  -v $(pwd)/results:/app/results \
  massivefinder example.com

# Usar docker-compose
docker-compose -f docker/docker-compose.yml run massive-finder example.com
```

## Processamento em Lote

```bash
# Arquivo de domínios (domains.txt)
example.com
example.org
example.net

# Executar em lote
./massive-finder.sh -f domains.txt

# Com output personalizado
./massive-finder.sh -f domains.txt -o batch_scan_$(date +%Y%m%d)
```

## Integração com Outras Ferramentas

```bash
# Usar resultados com Nuclei
./massive-finder.sh example.com -o scan
nuclei -l scan/active_subdomains_example.com.txt -t ~/nuclei-templates/

# Filtrar resultados específicos
cat scan/all_subdomains_example.com.txt | grep "api" | httpx -silent

# Converter para formato JSON
jq -R -n '[inputs]' scan/all_subdomains_example.com.txt > results.json
```

## Configuração Avançada

Edite o arquivo `config.env` para:

- Ajustar rate limiting
- Configurar proxies
- Modificar diretórios padrão
- Habilitar/desabilitar funcionalidades