# deploy_war.ps1 - Compila el WAR y hace hot deploy a Tomcat en contabo_marco
#
# Uso (desde congreso_back_end/):
#   powershell scripts/deploy_war.ps1              # mvn package + scp + hot deploy
#   powershell scripts/deploy_war.ps1 -SkipBuild   # reutiliza target/*.war ya compilado
#
# Que hace:
#   1. Compila con Maven (./mvnw clean package -DskipTests) [salvo -SkipBuild]
#   2. Copia el WAR a contabo_marco:/opt/tomcat10/webapps/congreso.war
#   3. Tomcat detecta el cambio y hace hot deploy (autoDeploy=true por default)
#   4. Verifica endpoint publico /api/organizadores/consultaTodos

param(
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$StartTime = Get-Date

$ScriptDir      = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot    = Split-Path -Parent $ScriptDir
$TargetDir      = Join-Path $ProjectRoot "target"
$SshHost        = "contabo_marco"
$RemoteWarPath  = "/opt/tomcat10/webapps/congreso.war"
$RemoteContext  = "/opt/tomcat10/webapps/congreso"
$ProductionApi  = "https://www.congresounisud.com:8444/congreso/api/organizadores/consultaTodos"

Write-Host ""
Write-Host "============================================="
Write-Host " Congreso Backend Deploy"
Write-Host "============================================="
Write-Host ""

# 1. Build
if (-not $SkipBuild) {
    Write-Host "[1/4] Compilando WAR (mvn clean package -DskipTests)..."
    Push-Location $ProjectRoot
    try {
        if ($IsWindows -or $env:OS -eq "Windows_NT") {
            & .\mvnw.cmd clean package -DskipTests
        } else {
            & ./mvnw clean package -DskipTests
        }
        if ($LASTEXITCODE -ne 0) { throw "mvn package fallo (exit $LASTEXITCODE)" }
    } finally {
        Pop-Location
    }
    Write-Host "[1/4] Compilacion completada."
} else {
    Write-Host "[1/4] Skip build (-SkipBuild)."
}
Write-Host ""

# 2. Localizar el WAR
$War = Get-ChildItem -Path $TargetDir -Filter "*.war" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $War) {
    throw "No se encontro ningun .war en $TargetDir. Compila primero o quita -SkipBuild."
}
$WarSizeMb = [math]::Round($War.Length / 1MB, 1)
Write-Host "[2/4] WAR: $($War.Name) (${WarSizeMb} MB)"
Write-Host ""

# 3. Deploy
Write-Host "[3/4] Copiando a $SshHost : $RemoteWarPath ..."
$DeployStart = Get-Date

# Subir primero como .war.new para atomicidad (Tomcat no ve el archivo parcial)
$RemoteTmp = "$RemoteWarPath.new"
& scp $War.FullName "${SshHost}:${RemoteTmp}"
if ($LASTEXITCODE -ne 0) { throw "scp fallo al copiar WAR" }

# Borrar contexto expandido + mover el nuevo war en una sola operacion
# Tomcat detectara el cambio de mtime en el .war y re-expandira
& ssh $SshHost "rm -rf $RemoteContext && mv $RemoteTmp $RemoteWarPath && chown tomcat:tomcat $RemoteWarPath 2>/dev/null; chmod 644 $RemoteWarPath && echo DEPLOYED"
if ($LASTEXITCODE -ne 0) { throw "ssh fallo al remplazar WAR remoto" }

$DeployDuration = [math]::Round(((Get-Date) - $DeployStart).TotalSeconds, 1)
Write-Host "[3/4] Deploy enviado en ${DeployDuration}s. Esperando hot deploy..."
Write-Host ""

# 4. Verificacion (poll hasta 60s esperando que Tomcat re-deploy)
Write-Host "[4/4] Verificando $ProductionApi ..."
$Ok = $false
$Attempts = 0
$MaxAttempts = 30  # 30 x 2s = 60s
while (-not $Ok -and $Attempts -lt $MaxAttempts) {
    Start-Sleep -Seconds 2
    $Attempts++
    try {
        $Check = Invoke-WebRequest -Uri $ProductionApi -UseBasicParsing -TimeoutSec 5
        if ($Check.StatusCode -ge 200 -and $Check.StatusCode -lt 500) {
            $Ok = $true
            Write-Host "[4/4] OK - HTTP $($Check.StatusCode) tras $($Attempts * 2)s"
        }
    } catch {
        # Tomcat esta re-deployando, reintento
    }
}

if (-not $Ok) {
    Write-Warning "[4/4] No se obtuvo respuesta OK en 60s. Revisa logs: ssh $SshHost 'tail -50 /opt/tomcat10/logs/catalina.out'"
}

$TotalDuration = [math]::Round(((Get-Date) - $StartTime).TotalMinutes, 1)
Write-Host ""
Write-Host "============================================="
Write-Host " Listo."
Write-Host " WAR: $($War.Name) (${WarSizeMb} MB)"
Write-Host " Servidor: $SshHost"
Write-Host " Verificacion: $(if ($Ok) {'OK'} else {'FALLIDA'})"
Write-Host " Duracion: ${TotalDuration} min"
Write-Host "============================================="
