#!/bin/sh
set -e

cd /app

# BD persistente no /data (mapeado pelo HA Supervisor)
export DB_PATH=/data/energia.db

# Debug: verificar token
echo "SUPERVISOR_TOKEN set: $(test -n "$SUPERVISOR_TOKEN" && echo YES || echo NO)"

# Obter ingress_entry do Supervisor API via curl
INGRESS_ENTRY=""
if [ -n "$SUPERVISOR_TOKEN" ]; then
  RESULT=$(curl -s -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/addons/self/info 2>&1)
  echo "Supervisor API response: ${RESULT}"
  INGRESS_ENTRY=$(echo "$RESULT" | python3 -c "import json,sys; print(json.load(sys.stdin)['data']['ingress_entry'])" 2>/dev/null || echo "")
fi

export ROOT_PATH="${INGRESS_ENTRY:-}"
echo "ROOT_PATH: ${ROOT_PATH}"

# Migracoes
alembic upgrade head

# Arrancar na porta definida pelo HA (ingress_port no config.yaml)
exec python3 -m uvicorn src.web.app:app \
  --host 0.0.0.0 \
  --port 8099 \
  --root-path "$ROOT_PATH"
