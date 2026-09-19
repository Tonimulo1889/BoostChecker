@echo off
title Boost Roleplay PC-Checker
cd /d "C:\Users\OBSSB\.gemini\antigravity\scratch\BoostChecker"

powershell.exe -ExecutionPolicy Bypass -NoProfile -STA -File "C:\Users\OBSSB\.gemini\antigravity\scratch\BoostChecker\Launch.ps1"
if %errorlevel% neq 0 (
    echo.
    echo ==========================================================
    echo  FEHLER: Das Programm konnte nicht gestartet werden.
    echo ==========================================================
    echo Fehlernummer: %errorlevel%
    pause
)
