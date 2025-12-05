#!/bin/bash
set -e

: "${POSTGRES_USER:=postgres}"

for DB in flutter_db laravel_db node_db; do
  exists=$(psql -U "$POSTGRES_USER" -tAc "SELECT 1 FROM pg_database WHERE datname='$DB';")
  if [ "$exists" != "1" ]; then
    echo "Creating database: $DB"
    psql -U "$POSTGRES_USER" -c "CREATE DATABASE \"$DB\";"
  else
    echo "Database $DB already exists, skipping."
  fi
done