#!/bin/bash
# Prepara o add-on copiando o codigo fonte para a pasta ha-addon/
# Correr a partir da raiz do projecto: ./ha-addon/build-addon.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "A copiar codigo fonte para $SCRIPT_DIR ..."

# Copiar src/
rsync -av --delete \
  --exclude='__pycache__' --exclude='*.pyc' \
  "$PROJECT_ROOT/src/" "$SCRIPT_DIR/src/"

# Copiar config/
rsync -av --delete \
  "$PROJECT_ROOT/config/" "$SCRIPT_DIR/config/"

# Copiar ficheiros soltos
cp "$PROJECT_ROOT/alembic.ini" "$SCRIPT_DIR/"
cp "$PROJECT_ROOT/requirements-docker.txt" "$SCRIPT_DIR/"

echo "Pronto. Podes agora fazer push do repositorio e instalar no HA."
