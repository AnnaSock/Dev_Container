FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    PASSWORD=devpass

RUN apt-get update && apt-get install -y --no-install-recommends \
	php php-cli php-mbstring php-xml php-curl unzip curl git sudo ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installer code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN useradd -m dev && mkdir -p /workspace && chown dev:dev /workspace

WORKDIR /workspace
EXPOSE 8080

USER dev
ENV HOME=/home/dev
CMD ["sh", "-c", "PASSWORD=${PASSWORD} code-server --bind-addr 0.0.0.0:8080 --auth password /workspace"]