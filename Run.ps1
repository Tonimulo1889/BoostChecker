# ==============================================================================
# BOOST ROLEPLAY - OFFICIAL PC-CHECKER CLIENT LAUNCHER
# Exclusive In-House Forensic Suite for Boost Roleplay
# Usage: irm https://raw.githubusercontent.com/Tonimulo1889/BoostChecker/main/Run.ps1 | iex
# ==============================================================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = "Stop"

# Administrator-Rechte pruefen
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host ""
    Write-Host " [!] Administrator-Rechte werden fuer den FiveM PC-Check benoetigt..." -ForegroundColor Yellow
    Write-Host " [*] Bitte bestaetige den Windows-UAC-Dialog..." -ForegroundColor Cyan
    try {
        Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://raw.githubusercontent.com/Tonimulo1889/BoostChecker/main/Run.ps1 | iex`""
        exit
    } catch {
        Write-Host " [-] Start als Administrator abgebrochen." -ForegroundColor Red
        return
    }
}

Write-Host ""
Write-Host " ================================================================= " -ForegroundColor Magenta
Write-Host "       BOOST ROLEPLAY - EXCLUSIVE FIVE-M FORENSIC PC-CHECKER       " -ForegroundColor White
Write-Host " ================================================================= " -ForegroundColor Magenta
Write-Host ""
Write-Host " [*] Verbinde mit sicherem Boost Roleplay Release-Server..." -ForegroundColor Cyan

$tempRoot = Join-Path $env:TEMP "BoostChecker_Client"
$zipPath = Join-Path $env:TEMP "BoostChecker_Latest.zip"
$zipUrl = "https://github.com/Tonimulo1889/BoostChecker/archive/refs/heads/main.zip"

try {
    # 1. Download Repository
    Write-Host " [*] Lade aktuelle Sicherheitskomponenten..." -ForegroundColor Cyan
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($zipUrl, $zipPath)
    $wc.Dispose()

    # 2. Extract
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
    [void](New-Item -ItemType Directory -Path $tempRoot -Force)

    Write-Host " [*] Initialisiere Forensik-Module..." -ForegroundColor Cyan
    Expand-Archive -Path $zipPath -DestinationPath $tempRoot -Force
    Remove-Item -LiteralPath $zipPath -Force -ErrorAction SilentlyContinue

    $extractedRoot = Join-Path $tempRoot "BoostChecker-main"
    if (-not (Test-Path -LiteralPath $extractedRoot)) {
        $extractedRoot = (Get-ChildItem -Path $tempRoot -Directory | Select-Object -First 1).FullName
    }

    $launcher = Join-Path $extractedRoot "Launch.ps1"
    if (-not (Test-Path -LiteralPath $launcher)) {
        throw "Launch.ps1 wurde im Paket nicht gefunden."
    }

    Write-Host " [OK] Starte Boost Roleplay Security Suite..." -ForegroundColor Green
    Start-Process powershell.exe -WorkingDirectory $extractedRoot -ArgumentList @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-STA",
        "-File", "`"$launcher`""
    ) -Wait
}
catch {
    Write-Host ""
    Write-Host " [-] Fehler bei der Initialisierung: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host " Bitte wende dich an die Boost Roleplay Serverleitung." -ForegroundColor Yellow
    Read-Host " Druecke Enter zum Beenden..."
}
finally {
    # Aufraeumen nach Beendigung
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
