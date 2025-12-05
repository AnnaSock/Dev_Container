#!/bin/bash
set -e

echo "🚀 Initialisation de l'environnement Codespaces..."

# Installer yarn
npm install -g yarn

# Installer Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installer Flutter (minimal)
echo "📦 Installation de Flutter..."
git clone --depth 1 https://github.com/flutter/flutter.git /usr/local/flutter || true
export PATH="/usr/local/flutter/bin:$PATH"
flutter config --no-analytics
flutter --version || echo "Flutter installation en cours..."

# Créer les dossiers workspace s'ils n'existent pas
mkdir -p /workspace/php
mkdir -p /workspace/node
mkdir -p /workspace/flutter

echo "✅ Environnement Codespaces prêt!"
echo "📝 PHP: $(php -v | head -1)"
echo "📝 Node: $(node -v)"
echo "📝 npm: $(npm -v)"
echo "📝 Composer: $(composer -V | head -1)"
echo "📝 Yarn: $(yarn -v)"
echo "📝 Flutter: $(flutter --version | head -1)"
