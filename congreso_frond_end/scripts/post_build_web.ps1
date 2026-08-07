# post_build_web.ps1 — Ejecutar despues de: flutter build web --release
# Post-procesamiento de cache para Congreso UNISUD web:
#   1. Genera version.json con build_number (lo que espera el update checker de index.html)
#   2. Inyecta build_number en custom-sw.js (rota el nombre del cache en cada build)
#   3. Copia .htaccess al build (reglas de cache de Apache)
#   4. Remueve serviceWorkerSettings de flutter_bootstrap.js (evita conflicto con custom-sw.js)
#   5. Elimina flutter_service_worker.js deprecado del build
#   6. Reemplaza BUILD_TIMESTAMP en index.html con build_number
#
# Uso:
#   cd congreso_frond_end/
#   flutter build web --release
#   powershell scripts/post_build_web.ps1

$ErrorActionPreference = "Stop"

$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$BuildDir    = Join-Path $ProjectRoot "build\web"
$WebDir      = Join-Path $ProjectRoot "web"

if (-not (Test-Path $BuildDir)) {
    Write-Error "ERROR: '$BuildDir' no existe. Ejecuta 'flutter build web --release' primero."
    exit 1
}

# ── 1. Leer version de pubspec.yaml ────────────────────────────────────────────
$PubspecPath = Join-Path $ProjectRoot "pubspec.yaml"
$PubspecContent = Get-Content $PubspecPath -Raw
if ($PubspecContent -match "(?m)^version:\s*(\S+)") {
    $VersionFull = $Matches[1]
} else {
    Write-Error "ERROR: No se encontro 'version:' en pubspec.yaml"
    exit 1
}

$Version     = $VersionFull -replace '\+.*', ''
$BuildNumber = $VersionFull -replace '.*\+', ''
$BuildTimestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

# ── 2. Hash de git (solo para informe) ─────────────────────────────────────────
try {
    $Hash = (& git -C $ProjectRoot rev-parse --short HEAD 2>$null).Trim()
    if ([string]::IsNullOrWhiteSpace($Hash)) { throw "empty" }
} catch {
    $Hash = (Get-Date -Format "yyyyMMddHHmm")
}

Write-Host "[post_build] Version: $VersionFull | Build: $BuildNumber | Hash: $Hash"
Write-Host ""

# ── 3. Generar version.json ──────────────────────────────────────────────────
$VersionJsonPath = Join-Path $BuildDir "version.json"
$VersionJson = @{
    app_name        = "congreso_evento"
    version         = $Version
    build_number    = $BuildNumber
    package_name    = "congreso_evento"
    build_timestamp = $BuildTimestamp
}
$VersionJsonStr = $VersionJson | ConvertTo-Json -Compress
[System.IO.File]::WriteAllText($VersionJsonPath, $VersionJsonStr)
Write-Host "[post_build] [1/6] version.json: $VersionJsonStr"

# ── 4. Inyectar build_number en custom-sw.js ──────────────────────────────────
$SwPath = Join-Path $BuildDir "custom-sw.js"
if (Test-Path $SwPath) {
    $SwContent = Get-Content $SwPath -Raw
    $SwContent = $SwContent -replace 'BUILD_NUMBER_PLACEHOLDER', $BuildNumber
    [System.IO.File]::WriteAllText($SwPath, $SwContent)
    Write-Host "[post_build] [2/6] custom-sw.js: CACHE_VERSION = '$BuildNumber'"
} else {
    Write-Warning "[post_build] [2/6] WARN: custom-sw.js no encontrado en build\web\"
}

# ── 5. Copiar .htaccess ───────────────────────────────────────────────────────
$HtaccessSrc = Join-Path $WebDir ".htaccess"
$HtaccessDst = Join-Path $BuildDir ".htaccess"
if (Test-Path $HtaccessSrc) {
    Copy-Item $HtaccessSrc $HtaccessDst -Force
    Write-Host "[post_build] [3/6] .htaccess copiado a build\web\"
} else {
    Write-Warning "[post_build] [3/6] WARN: web\.htaccess no encontrado"
}

# ── 6. Remover serviceWorkerSettings de flutter_bootstrap.js ─────────────────
$BootstrapPath = Join-Path $BuildDir "flutter_bootstrap.js"
if (Test-Path $BootstrapPath) {
    node -e @"
const fs = require('fs');
const f = '$($BootstrapPath -replace '\\', '/')';
let src = fs.readFileSync(f, 'utf8');
const updated = src.replace(/_flutter\.loader\.load\(\{[\s\S]*?\}\);/, '_flutter.loader.load();');
fs.writeFileSync(f, updated);
"@
    if ($LASTEXITCODE -ne 0) {
        Write-Error "[post_build] [4/6] ERROR: node fallo al procesar flutter_bootstrap.js"
        exit 1
    }
    $BootstrapContent = Get-Content $BootstrapPath -Raw
    if ($BootstrapContent -match '_flutter\.loader\.load\(\);') {
        Write-Host "[post_build] [4/6] flutter_bootstrap.js: serviceWorkerSettings removido"
    } else {
        Write-Warning "[post_build] [4/6] WARN: serviceWorkerSettings puede no haberse removido"
    }
} else {
    Write-Warning "[post_build] [4/6] WARN: flutter_bootstrap.js no encontrado"
}

# ── 7. Eliminar flutter_service_worker.js deprecado ──────────────────────────
$DeprecatedSw = Join-Path $BuildDir "flutter_service_worker.js"
if (Test-Path $DeprecatedSw) {
    Remove-Item $DeprecatedSw -Force
    Write-Host "[post_build] [5/6] flutter_service_worker.js eliminado (deprecado)"
} else {
    Write-Host "[post_build] [5/6] flutter_service_worker.js no existe (ya limpio)"
}

# ── 8. Copiar index.html fuente y reemplazar BUILD_TIMESTAMP con build_number ─
$IndexSrc = Join-Path $WebDir "index.html"
$IndexDst = Join-Path $BuildDir "index.html"
if (Test-Path $IndexSrc) {
    $Html = Get-Content $IndexSrc -Raw
    $Html = $Html -replace 'BUILD_TIMESTAMP', $BuildNumber
    [System.IO.File]::WriteAllText($IndexDst, $Html)
    Write-Host "[post_build] [6/6] index.html: BUILD_TIMESTAMP -> '$BuildNumber'"
} else {
    Write-Warning "[post_build] [6/6] WARN: web\index.html no encontrado"
}

Write-Host ""
Write-Host "[post_build] Listo: v$VersionFull ($Hash)"
Write-Host "[post_build] Build en: build\web\"
