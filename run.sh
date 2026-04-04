#!/bin/sh
set -e

cd /app

# BD persistente no /data (mapeado pelo HA Supervisor)
export DB_PATH=/data/energia.db

# Obter ingress_entry do Supervisor API
INGRESS_ENTRY=$(python3 -c "
import urllib.request, json, os
token = os.environ.get('SUPERVISOR_TOKEN', '')
req = urllib.request.Request(
    'http://supervisor/addons/self/info',
    headers={'Authorization': 'Bearer ' + token}
)
try:
    data = json.loads(urllib.request.urlopen(req).read())
    print(data['data']['ingress_entry'])
except Exception:
    print('')
" 2>/dev/null)

export ROOT_PATH="${INGRESS_ENTRY:-}"
echo "Ingress entry: ${ROOT_PATH}"

# Migracoes
alembic upgrade head

# Arrancar na porta definida pelo HA (ingress_port no config.yaml)
exec python3 -m uvicorn src.web.app:app \
  --host 0.0.0.0 \
  --port 8099 \
  --root-path "$ROOT_PATH"
