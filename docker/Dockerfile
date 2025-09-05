FROM ubuntu:22.04

LABEL maintainer="BackTrackSec"
LABEL version="1.0"
LABEL description="MassiveFinder - Subdomain Enumeration Pipeline"

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git curl wget jq python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Instalar Go
RUN wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz -O /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

# Configurar environment
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# Criar diretório de trabalho
WORKDIR /app

# Copiar arquivos do projeto
COPY .. .

# Instalar ferramentas
RUN chmod +x tools/install_tools.sh && ./tools/install_tools.sh

# Configurar permissões
RUN chmod +x massive-finder.sh

# Definir ponto de entrada
ENTRYPOINT ["./massive-finder.sh"]
CMD ["--help"]