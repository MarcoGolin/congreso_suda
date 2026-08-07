#!/usr/bin/env bash
# deploy_war.sh - Compila el WAR y hace hot deploy a Tomcat en contabo_marco
#
# Uso (desde congreso_back_end/):
#   bash scripts/deploy_war.sh              # mvn package + scp + hot deploy
#   bash scripts/deploy_war.sh --skip-build # reutiliza target/*.war ya compilado
#
# Que hace:
#   1. Compila con Maven (./mvnw clean package -DskipTests) [salvo --skip-build]
#   2. Copia el WAR a contabo_marco:/opt/tomcat10/webapps/congreso.war
#   3. Tomcat detecta el cambio y hace hot deploy
#   4. Verifica endpoint publico /api/organizadores/consultaTodos

set -euo pipefail

SKIP_BUILD=false
for arg in "$@"; do
  case "$arg" in
    --skip-build) SKIP_BUILD=true ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TARGET_DIR="$PROJECT_ROOT/target"
SSH_HOST="contabo_marco"
REMOTE_WAR_PATH="/opt/tomcat10/webapps/congreso.war"
REMOTE_CONTEXT="/opt/tomcat10/webapps/congreso"
PRODUCTION_API="https://www.congresounisud.com:8444/congreso/api/organizadores/consultaTodos"

echo ""
echo "============================================="
echo " Congreso Backend Deploy"
echo "============================================="
echo ""

# 1. Build
if [ "$SKIP_BUILD" = false ]; then
  echo "[1/4] Compilando WAR (mvn clean package -DskipTests)..."
  (cd "$PROJECT_ROOT" && ./mvnw clean package -DskipTests)
  echo "[1/4] Compilacion completada."
else
  echo "[1/4] Skip build (--skip-build)."
fi
echo ""

# 2. Localizar el WAR
WAR=$(ls -1 "$TARGET_DIR"/*.war 2>/dev/null | head -1 || true)
if [ -z "$WAR" ]; then
  echo "ERROR: No se encontro ningun .war en $TARGET_DIR."
  exit 1
fi
WAR_NAME=$(basename "$WAR")
WAR_SIZE=$(du -m "$WAR" | cut -f1)
echo "[2/4] WAR: $WAR_NAME (${WAR_SIZE} MB)"
echo ""

# 3. Deploy
echo "[3/4] Copiando a $SSH_HOST : $REMOTE_WAR_PATH ..."
START=$(date +%s)

REMOTE_TMP="${REMOTE_WAR_PATH}.new"
scp "$WAR" "${SSH_HOST}:${REMOTE_TMP}"

ssh "$SSH_HOST" "rm -rf $REMOTE_CONTEXT && mv $REMOTE_TMP $REMOTE_WAR_PATH && (chown tomcat:tomcat $REMOTE_WAR_PATH 2>/dev/null || true) && chmod 644 $REMOTE_WAR_PATH && echo DEPLOYED"

DURATION=$(( $(date +%s) - START ))
echo "[3/4] Deploy enviado en ${DURATION}s. Esperando hot deploy..."
echo ""

# 4. Verificacion
echo "[4/4] Verificando $PRODUCTION_API ..."
OK=false
for i in $(seq 1 30); do
  sleep 2
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$PRODUCTION_API" || echo "000")
  if [[ "$STATUS" =~ ^[2-4][0-9][0-9]$ ]]; then
    OK=true
    echo "[4/4] OK - HTTP $STATUS tras $((i * 2))s"
    break
  fi
done

if [ "$OK" = false ]; then
  echo "[4/4] WARN: No se obtuvo respuesta OK en 60s."
  echo "       Revisa logs: ssh $SSH_HOST 'tail -50 /opt/tomcat10/logs/catalina.out'"
fi

echo ""
echo "============================================="
echo " Listo."
echo " WAR: $WAR_NAME (${WAR_SIZE} MB)"
echo " Servidor: $SSH_HOST"
echo " Verificacion: $([ "$OK" = true ] && echo OK || echo FALLIDA)"
echo "============================================="
