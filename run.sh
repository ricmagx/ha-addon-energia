#!/bin/sh
set -e

cd /app

# BD persistente no /data (mapeado pelo HA Supervisor)
export DB_PATH=/data/energia.db

# Ingress: HA injeta INGRESS_ENTRY como base path
export ROOT_PATH="${INGRESS_ENTRY:-}"

# Migracoes
alembic upgrade head

# Arrancar na porta definida pelo HA (ingress_port no config.yaml)
exec python3 -m uvicorn src.web.app:app \
  --host 0.0.0.0 \
  --port 8099 \
  --root-path "$ROOT_PATH"
