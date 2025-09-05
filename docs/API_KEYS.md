# Configuração de API Keys no MassiveFinder

Para obter o máximo do MassiveFinder, configure as seguintes API keys:

## Chaos API Key

1. Acesse https://chaos.projectdiscovery.io
2. Faça login com sua conta GitHub
3. Gere uma nova API key
4. Adicione no config.env:
   ```
   CHAOS_API_KEY="sua_key_aqui"
   ```

## Subfinder API Keys

O Subfinder suporta múltiplas APIs. Configure no config.env:

```
SUBFINDER_API_KEYS="github-api-key,shodan-api-key,etc"
```

### Como obter cada API:

- **GitHub**: https://github.com/settings/tokens
- **Shodan**: https://account.shodan.io
- **SecurityTrails**: https://securitytrails.com
- **Censys**: https://censys.io
- **etc**

## Configuração Segura

Nunca commit seu arquivo config.env! Ele está listado no .gitignore por padrão.

Para uso em CI/CD, use variáveis de ambiente:

```bash
export CHAOS_API_KEY="sua_key"
export SUBFINDER_API_KEYS="key1,key2"
./massive-finder.sh example.com
```