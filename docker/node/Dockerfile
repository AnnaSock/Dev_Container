FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    PASSWORD=devpass

RUN apt-get update && apt-get install -y --no-install-recommends \
	curl gnupg git ca-certificates sudo build-essential \
	&& rm -rf /var/lib/apt/lists/*

# Node.js 20 LTS via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Installer yarn (optionnel)
RUN npm install -g yarn

# Installer code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN useradd -m dev && mkdir -p /workspace && chown dev:dev /workspace

WORKDIR /workspace
EXPOSE 8080

USER dev
ENV HOME=/home/dev
# Ajout d'un healthcheck pour vérifier que code-server répond sur le port 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://127.0.0.1:8080/ || exit 1

CMD ["sh", "-c", "PASSWORD=${PASSWORD} code-server --bind-addr 0.0.0.0:8080 --auth password /workspace"]