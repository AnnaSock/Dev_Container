FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    PASSWORD=devpass \
    PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
	curl git unzip wget ca-certificates build-essential sudo gnupg2 lsb-release \
	&& rm -rf /var/lib/apt/lists/*

# Installer Flutter (version stable minimale)
RUN git clone --depth 1 https://github.com/flutter/flutter.git /opt/flutter && \
    /opt/flutter/bin/flutter --version || true

# Installer code-server (VS Code Server)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Créer utilisateur de développement et workspace
RUN useradd -m dev && mkdir -p /workspace && chown dev:dev /workspace

WORKDIR /workspace
EXPOSE 8080

USER dev
ENV HOME=/home/dev
CMD ["sh", "-c", "PASSWORD=${PASSWORD} code-server --bind-addr 0.0.0.0:8080 --auth password /workspace"]