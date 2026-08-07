# build_web.ps1 - Build completo de Flutter Web + deploy a contabo_marco
#
# Uso (desde congreso_frond_end/):
#   powershell scripts/build_web.ps1             # build + deploy
#   powershell scripts/build_web.ps1 -NoDeploy   # solo build, sin subir
#
# Que hace:
#   1. Compila Flutter web en release
#   2. Post-build: version.json, custom-sw.js, .htaccess, flutter_bootstrap.js, index.html
#   3. Comprime build/web/ en tar.gz, sube al servidor, extrae y sincroniza via rsync
#   4. Verifica que la URL de produccion responde HTTP 200 con el build esperado
#   5. Genera informe detallado en build/

param(
    [switch]$NoDeploy
)

$ErrorActionPreference = "Stop"
$StartTime = Get-Date

$ScriptDir       = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot     = Split-Path -Parent $ScriptDir
$BuildDir        = Join-Path $ProjectRoot "build\web"
$ReportsDir      = Join-Path $ProjectRoot "build"
$SshHost         = "contabo_marco"
$RemoteWebPath   = "/var/www/congresounisud.com/"
$RemoteTmpPath   = "/tmp/congreso-web-deploy"
$ProductionUrl   = "https://www.congresounisud.com"

# Leer version de pubspec.yaml
$PubspecPath = Join-Path $ProjectRoot "pubspec.yaml"
$PubspecContent = Get-Content $PubspecPath -Raw
if ($PubspecContent -match "(?m)^version:\s*(\S+)") {
    $Version = $Matches[1]
} else {
    Write-Error "ERROR: No se encontro 'version:' en pubspec.yaml"
    exit 1
}

try {
    $Hash = (& git -C $ProjectRoot rev-parse --short HEAD 2>$null).Trim()
    if ([string]::IsNullOrWhiteSpace($Hash)) { throw "empty" }
} catch {
    $Hash = (Get-Date -Format "yyyyMMddHHmm")
}

Write-Host ""
Write-Host "============================================="
Write-Host " Congreso Web Build  -  v$Version"
Write-Host "============================================="
Write-Host ""

# 1. Compilar Flutter web
Write-Host "[1/5] Compilando Flutter web (release)..."
Push-Location $ProjectRoot
try {
    & flutter build web --release
    if ($LASTEXITCODE -ne 0) { throw "flutter build web fallo (exit $LASTEXITCODE)" }
} finally {
    Pop-Location
}
Write-Host "[1/5] Compilacion completada."
Write-Host ""

# 2. Post-build
Write-Host "[2/5] Ejecutando post-build (version.json, cache-bust, SW)..."
$PostBuildScript = Join-Path $ScriptDir "post_build_web.ps1"
& powershell -File $PostBuildScript
if ($LASTEXITCODE -ne 0) { throw "post_build_web.ps1 fallo (exit $LASTEXITCODE)" }
Write-Host ""

$DeployStatus     = "OMITIDO (-NoDeploy)"
$DeployDuration   = 0
$FilesTransferred = 0
$VerifyStatus     = "N/A"

if (-not $NoDeploy) {
    # 3. Deploy via tar.gz + rsync
    Write-Host "[3/5] Comprimiendo y subiendo build/web/ a ($SshHost)..."
    $DeployStart = Get-Date

    $TarFile = Join-Path ([System.IO.Path]::GetTempPath()) "congreso-web-$Version.tar.gz"
    Write-Host "      Comprimiendo..."
    $CompressStart = Get-Date
    & tar -czf $TarFile -C $BuildDir .
    if ($LASTEXITCODE -ne 0) { throw "tar: fallo al comprimir build/web/" }
    $TarSize = [math]::Round((Get-Item $TarFile).Length / 1MB, 1)
    $CompressDuration = [math]::Round(((Get-Date) - $CompressStart).TotalSeconds, 1)
    Write-Host "      Comprimido: ${TarSize} MB (${CompressDuration}s)"

    $RemoteTarPath = "/tmp/congreso-web-$Version.tar.gz"
    Write-Host "      Transfiriendo tar.gz..."
    & scp $TarFile "${SshHost}:${RemoteTarPath}"
    if ($LASTEXITCODE -ne 0) {
        Remove-Item $TarFile -Force
        throw "scp fallo al transferir tar.gz a $SshHost"
    }
    Remove-Item $TarFile -Force

    Write-Host "      Extrayendo y sincronizando en servidor..."
    & ssh $SshHost "rm -rf $RemoteTmpPath && mkdir -p $RemoteTmpPath && tar -xzf $RemoteTarPath -C $RemoteTmpPath && rm -f $RemoteTarPath"
    if ($LASTEXITCODE -ne 0) { throw "SSH: fallo al extraer tar.gz en servidor" }

    $RsyncOut = & ssh $SshHost "rsync -avz --delete --checksum $RemoteTmpPath/ $RemoteWebPath 2>&1"
    if ($LASTEXITCODE -ne 0) { throw "rsync en servidor fallo" }

    $FilesTransferred = ($RsyncOut | Where-Object { $_ -match "^[^\s]" -and $_ -notmatch "^(sending|sent|total|$)" }).Count

    & ssh $SshHost "rm -rf $RemoteTmpPath"

    $DeployDuration = [math]::Round(((Get-Date) - $DeployStart).TotalSeconds, 1)
    $DeployStatus = "OK (${DeployDuration}s, ~$FilesTransferred archivos)"
    Write-Host "[3/5] Deploy completado en ${DeployDuration}s."
    Write-Host ""

    # 4. Verificar deploy
    Write-Host "[4/5] Verificando produccion ($ProductionUrl)..."
    Start-Sleep -Seconds 3
    try {
        $Check = Invoke-WebRequest -Uri "$ProductionUrl/version.json?_t=$(Get-Random)" -UseBasicParsing -Headers @{ "Cache-Control" = "no-cache" }
        $Body = $Check.Content -replace '^\xEF\xBB\xBF', ''
        if ($Body -match '^\s*\{') {
            $RemoteJson = $Body | ConvertFrom-Json
            $RemoteBuild = $RemoteJson.build_number
            $ExpectedBuild = ($Version -replace '.*\+', '')
            $VerifyStatus = "HTTP $($Check.StatusCode) OK - build remoto: $RemoteBuild"
            if ($RemoteBuild -eq $ExpectedBuild) {
                Write-Host "[4/5] OK - version.json remoto coincide: build $RemoteBuild"
            } else {
                Write-Warning "[4/5] ADVERTENCIA: version.json remoto es build $RemoteBuild (esperaba $ExpectedBuild)"
            }
        } else {
            $VerifyStatus = "ADVERTENCIA: version.json no retorno JSON valido"
            Write-Warning "[4/5] $VerifyStatus"
        }
    } catch {
        $VerifyStatus = "ADVERTENCIA: No se pudo verificar - $_"
        Write-Warning "[4/5] $VerifyStatus"
    }
    Write-Host ""
} else {
    Write-Host "[3-4/5] Deploy omitido (-NoDeploy)."
    Write-Host ""
}

# 5. Generar informe
Write-Host "[5/5] Generando informe..."

$TotalDuration = [math]::Round(((Get-Date) - $StartTime).TotalMinutes, 1)
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$ReportPath = Join-Path $ReportsDir "web_deploy_report_$($Version.Replace('+','_')).md"

$Report = @"
# Congreso Web Deploy Report

| Campo | Valor |
|---|---|
| **Version** | $Version |
| **Git Hash** | $Hash |
| **Fecha** | $Timestamp |
| **Duracion total** | ${TotalDuration} min |

## Deploy

| Campo | Valor |
|---|---|
| **Estado** | $DeployStatus |
| **Servidor** | $SshHost ($RemoteWebPath) |
| **Archivos transferidos** | ~$FilesTransferred |
| **Verificacion** | $VerifyStatus |
| **URL produccion** | $ProductionUrl |

---
*Generado por build_web.ps1*
"@

New-Item -ItemType Directory -Path $ReportsDir -Force | Out-Null
Set-Content -Path $ReportPath -Value $Report -Encoding UTF8
Write-Host "[5/5] Informe guardado: $ReportPath"
Write-Host ""

Write-Host "============================================="
Write-Host " Listo: v$Version ($Hash)"
Write-Host " Deploy: $DeployStatus"
Write-Host " URL: $ProductionUrl"
Write-Host " Duracion: ${TotalDuration} min"
Write-Host "============================================="
