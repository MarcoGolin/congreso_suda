#!/usr/bin/env bash
# post_build_web.sh — Ejecutar después de: flutter build web --release
# Post-procesamiento de cache para Congreso UNISUD web:
#   1. Genera version.json con build_number (lo que espera el update checker de index.html)
#   2. Inyecta build_number en custom-sw.js (rota el nombre del cache en cada build)
#   3. Copia .htaccess al build (reglas de cache de Apache)
#   4. Remueve serviceWorkerSettings de flutter_bootstrap.js (evita conflicto con custom-sw.js)
#   5. Elimina flutter_service_worker.js deprecado del build
#   6. Reemplaza BUILD_TIMESTAMP en index.html con build_number (cache-bust en ?v=...)
#
# Uso:
#   cd congreso_frond_end/
#   flutter build web --release
#   bash scripts/post_build_web.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_ROOT/build/web"
WEB_DIR="$PROJECT_ROOT/web"

if [ ! -d "$BUILD_DIR" ]; then
  echo "ERROR: '$BUILD_DIR' no existe. Ejecuta 'flutter build web --release' primero."
  exit 1
fi

# ── 1. Leer version de pubspec.yaml ────────────────────────────────────────────
VERSION_FULL=$(grep -m1 "^version:" "$PROJECT_ROOT/pubspec.yaml" | sed 's/version:[[:space:]]*//' | tr -d '[:space:]')
if [ -z "$VERSION_FULL" ]; then
  echo "ERROR: No se encontró 'version:' en pubspec.yaml"
  exit 1
fi

VERSION="${VERSION_FULL%%+*}"
BUILD_NUMBER="${VERSION_FULL##*+}"
BUILD_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# ── 2. Hash de git (solo para informe) ────────────────────────────────────────
HASH=$(git -C "$PROJECT_ROOT" rev-parse --short HEAD 2>/dev/null || date +%Y%m%d%H%M)

echo "[post_build] Version: $VERSION_FULL | Build: $BUILD_NUMBER | Hash: $HASH"
echo ""

# ── 3. Generar version.json (formato esperado por index.html update checker) ──
VERSION_JSON_PATH="$BUILD_DIR/version.json"
printf '{"app_name":"congreso_evento","version":"%s","build_number":"%s","package_name":"congreso_evento","build_timestamp":"%s"}' \
  "$VERSION" "$BUILD_NUMBER" "$BUILD_TIMESTAMP" > "$VERSION_JSON_PATH"
echo "[post_build] [1/6] version.json: $(cat "$VERSION_JSON_PATH")"

# ── 4. Inyectar build_number en custom-sw.js ──────────────────────────────────
SW_PATH="$BUILD_DIR/custom-sw.js"
if [ -f "$SW_PATH" ]; then
  sed -i "s/BUILD_NUMBER_PLACEHOLDER/$BUILD_NUMBER/g" "$SW_PATH"
  echo "[post_build] [2/6] custom-sw.js: CACHE_VERSION = '$BUILD_NUMBER'"
else
  echo "[post_build] [2/6] WARN: custom-sw.js no encontrado en build/web/"
fi

# ── 5. Copiar .htaccess ───────────────────────────────────────────────────────
HTACCESS_SRC="$WEB_DIR/.htaccess"
if [ -f "$HTACCESS_SRC" ]; then
  cp "$HTACCESS_SRC" "$BUILD_DIR/.htaccess"
  echo "[post_build] [3/6] .htaccess copiado a build/web/"
else
  echo "[post_build] [3/6] WARN: web/.htaccess no encontrado"
fi

# ── 6. Remover serviceWorkerSettings de flutter_bootstrap.js ─────────────────
BOOTSTRAP_PATH="$BUILD_DIR/flutter_bootstrap.js"
if [ -f "$BOOTSTRAP_PATH" ]; then
  node -e "
const fs = require('fs');
const f = '$BOOTSTRAP_PATH';
let src = fs.readFileSync(f, 'utf8');
const updated = src.replace(/_flutter\\.loader\\.load\\(\\{[\\s\\S]*?\\}\\);/, '_flutter.loader.load();');
fs.writeFileSync(f, updated);
"
  if grep -q '_flutter\.loader\.load();' "$BOOTSTRAP_PATH"; then
    echo "[post_build] [4/6] flutter_bootstrap.js: serviceWorkerSettings removido"
  else
    echo "[post_build] [4/6] WARN: serviceWorkerSettings puede no haberse removido (verificar manualmente)"
  fi
else
  echo "[post_build] [4/6] WARN: flutter_bootstrap.js no encontrado"
fi

# ── 7. Eliminar flutter_service_worker.js deprecado ──────────────────────────
DEPRECATED_SW="$BUILD_DIR/flutter_service_worker.js"
if [ -f "$DEPRECATED_SW" ]; then
  rm -f "$DEPRECATED_SW"
  echo "[post_build] [5/6] flutter_service_worker.js eliminado (deprecado)"
else
  echo "[post_build] [5/6] flutter_service_worker.js no existe (ya limpio)"
fi

# ── 8. Copiar index.html fuente y reemplazar BUILD_TIMESTAMP con build_number ─
INDEX_SRC="$WEB_DIR/index.html"
INDEX_DST="$BUILD_DIR/index.html"
if [ -f "$INDEX_SRC" ]; then
  cp "$INDEX_SRC" "$INDEX_DST"
  sed -i "s/BUILD_TIMESTAMP/$BUILD_NUMBER/g" "$INDEX_DST"
  echo "[post_build] [6/6] index.html: BUILD_TIMESTAMP → '$BUILD_NUMBER'"
else
  echo "[post_build] [6/6] WARN: web/index.html no encontrado"
fi

echo ""
echo "[post_build] Listo: v$VERSION_FULL ($HASH)"
echo "[post_build] Build en: build/web/"
