# Environnement Dev Multi-Langages Docker + VS Code Server + DBs

Deux approches de développement

Vous pouvez développer avec ce projet de deux façons :

**1) Docker Local (recommandé pour développement intensif)**
- Prérequis : Docker + Docker Compose + Git
- Avantages : Performance optimale, gratuit, contrôle total, pas de limites.
- Cas d'usage : Développement quotidien, production-like, travail lourd.
- Démarrage : `docker compose up -d <service>` → VS Code Server local sur 8081/8082/8083.

**2) GitHub Codespaces (recommandé pour flexibilité)**
- Prérequis : Compte GitHub + navigateur Internet
- Avantages : Accès depuis n'importe quel PC, environnement préconfiguré, pas d'installation locale.
- Limites : 60h/mois gratuit, puis $0.18/h; performances moindres que Docker local.
- Cas d'usage : Accès occasionnel, partage rapide, travail depuis plusieurs machines.
- Démarrage : Bouton "Code" → "Codespaces" → "Create codespace on main".

Structure:
- docker/flutter/Dockerfile
- docker/php-laravel/Dockerfile
- docker/node/Dockerfile
- docker-compose.yml
- init-postgres.sh

Spécifications:
- Base Ubuntu 24.04 pour les images dev, code-server configuré (mot de passe `devpass`).
- Ports VS Code Server:
  - Flutter: http://localhost:8081
  - PHP/Laravel: http://localhost:8082
  - Node: http://localhost:8083
- DBs:
  - PostgreSQL 16 (bases: `flutter_db`, `laravel_db`, `node_db`)
  - MySQL 8.0 (base initiale `laravel_db`)

Commandes globales (préparation)
1. Rendre le script d'init exécutable (une seule fois) :
   chmod +x init-postgres.sh

2. Construire toutes les images :
   docker compose build

3. Démarrer un service (avec les DBs automatiquement grâce à depends_on) :
   docker compose up -d <service>
   Exemples :
   - docker compose up -d flutter   # Flutter + DBs (8081)
   - docker compose up -d php       # PHP + DBs (8082)
   - docker compose up -d node      # Node + DBs (8083)

4. Arrêter :
   docker compose down

Accès aux logs et au shell des conteneurs
- Voir les logs d'un service :
  docker compose logs -f php
- Ouvrir un shell dans un service :
  docker compose exec php sh

Connexions aux bases depuis les conteneurs
- Postgres (service `postgres`):
  host=postgres port=5432 user=postgres password=postgres
  Bases créées : flutter_db, laravel_db, node_db (via init-postgres.sh)
- MySQL (service `mysql`):
  host=mysql port=3306 user=root password=root
  Base initiale : laravel_db

Étapes détaillées par environnement

1) PHP / Laravel (service "php", port VS Code: 8082)
- Préparer le workspace :
  - Créez ./workspace/php et placez votre projet Laravel dedans (ou clonez le dépôt).
- Construire l'image (si modifié) :
  docker compose build php
- Démarrer :
  docker compose up -d php
- Accéder à VS Code Server :
  Ouvrir http://localhost:8082 — mot de passe : devpass
- Installer dépendances et config :
  docker compose exec php sh
  # à l'intérieur du conteneur :
  composer install
  cp .env.example .env
  # Exemple de configuration DB (choisir postgres ou mysql)
  # Pour Postgres :
  DB_CONNECTION=pgsql
  DB_HOST=postgres
  DB_PORT=5432
  DB_DATABASE=laravel_db
  DB_USERNAME=postgres
  DB_PASSWORD=postgres
  # Pour MySQL :
  DB_CONNECTION=mysql
  DB_HOST=mysql
  DB_PORT=3306
  DB_DATABASE=laravel_db
  DB_USERNAME=root
  DB_PASSWORD=root
- Commandes Laravel courantes :
  php artisan key:generate
  php artisan migrate --force
  php artisan serve --host=0.0.0.0 --port=8000
  (Si vous utilisez php artisan serve, exposez le port dans docker-compose.yml si besoin.)
- Notes :
  - Utilisez docker compose logs -f php pour suivre.
  - Reconstruisez l'image si vous modifiez le Dockerfile : docker compose build php

2) Flutter (service "flutter", port VS Code: 8081)
- Préparer le workspace :
  - Créez ./workspace/flutter et placez-y votre projet Flutter.
- Construire l'image :
  docker compose build flutter
- Démarrer :
  docker compose up -d flutter
- Accéder à VS Code Server :
  Ouvrir http://localhost:8081 — mot de passe : devpass
- Travailler dans le conteneur :
  docker compose exec flutter sh
  # à l'intérieur :
  flutter pub get
  # Pour lancer l'app :
  flutter devices        # voir devices disponibles
  flutter run            # si un device est disponible (adb, émulateur ou web)
  # Pour le web :
  flutter build web
  # puis servir build/web (ex: python -m http.server 8085 dans build/web)
- Notes :
  - Si vous voulez exposer le serveur Web Flutter directement, ajoutez un port dans docker-compose.yml pour le mapping du port choisi.
  - Les commandes Flutter nécessitent parfois des dépendances système (SDK, adb) ; ajustez le Dockerfile si nécessaire.

3) Node (service "node", port VS Code: 8083)
- Préparer le workspace :
  - Créez ./workspace/node et placez-y votre projet.
- Construire l'image :
  docker compose build node
- Démarrer :
  docker compose up -d node
- Accéder à VS Code Server :
  Ouvrir http://localhost:8083 — mot de passe : devpass
- Installer dépendances et config :
  docker compose exec node sh
  # à l'intérieur :
  npm install  # ou yarn
  cp .env.example .env    # si présent
  # Exemple DB (Postgres)
  DB_HOST=postgres
  DB_PORT=5432
  DB_DATABASE=node_db
  DB_USERNAME=postgres
  DB_PASSWORD=postgres
- Lancer l'app :
  npm run dev   # ou npm run start
- Notes :
  - Si l'app écoute un port HTTP, exposez-le via docker-compose.yml si vous voulez y accéder depuis l'hôte.
  - Pour rebuild : docker compose build node

Utiliser dans GitHub Codespaces

Alternative sans Docker (recommandé pour Codespaces) :

1. Pousser le projet sur GitHub :
   git add .
   git commit -m "Init dev environment"
   git push origin main

2. Ouvrir dans Codespaces :
   - Depuis GitHub : bouton "Code" → "Codespaces" → "Create codespace on main"
   - Ou directement : https://codespaces.new/<username>/<repo-name>

3. À la création, `.devcontainer/devcontainer.json` s'exécute automatiquement :
   - Install PHP 8.3, Node 20, Flutter, Composer, yarn.
   - Configure extensions VS Code (Intelephense, ESLint, Dart, Flutter, etc.).
   - Monte /workspace en volume local ↔ Codespaces.

4. Démarrer dev directement :
   # PHP / Laravel
   cd /workspace/php
   composer install
   php artisan serve --host=0.0.0.0 --port=8000

   # Node
   cd /workspace/node
   npm install
   npm run dev

   # Flutter web
   cd /workspace/flutter
   flutter pub get
   flutter run -d web --web-port 8085

5. Ports automatiquement exposés :
   - 8000 : Laravel Dev Server
   - 8080 : Node Dev Server
   - 8081 : Flutter Web
   - 8082 : PHP Server
   - 8083 : Node Server

6. Synchronisation workspace :
   Les fichiers dans /workspace/php, /workspace/node, /workspace/flutter
   sont synchronisés bidirectionnellement avec votre machine locale.

Avantages Codespaces :
- Pas de Docker nested (meilleure perf que docker-compose dans Codespaces).
- Tous les outils installés directement.
- Extensions VS Code configurées automatiquement.
- Accès depuis n'importe quel navigateur.

Dépannage rapide
- Si les DBs ne sont pas initialisées : vérifiez que init-postgres.sh est exécutable et monté dans le conteneur postgres (chmod +x init-postgres.sh).
- Forcer la reconstruction : docker compose build --no-cache <service>
- Supprimer volumes (attention données): docker compose down -v

Bonnes pratiques
- Ne commitez pas de .env ni de secrets (le .gitignore fourni couvre ces cas).
- Pour modifications Dockerfile, rebuild + up -d.
- Gardez workspace/ monté en volume pour travail en temps réel.
- Si vous alternez Docker local ↔ Codespaces, nettoyez les conteneurs/volumes locaux régulièrement pour éviter les conflits.
