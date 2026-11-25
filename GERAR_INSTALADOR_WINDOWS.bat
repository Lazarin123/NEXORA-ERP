@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Nexora ERP 1.3.3 - Instalador Windows x64

echo ============================================================
echo   NEXORA ERP 1.3.3 - INSTALADOR WINDOWS x64 (NSIS)
echo ============================================================
echo.
where node >nul 2>nul
if errorlevel 1 (echo ERRO: instale Node.js LTS pelo site https://nodejs.org/ & goto :fail)
where npm >nul 2>nul
if errorlevel 1 (echo ERRO: npm nao foi encontrado no PATH. & goto :fail)
cd /d "%~dp0desktop-app"
if not exist "index.html" (echo ERRO: desktop-app\index.html ausente. Extraia o ZIP inteiro. & goto :fail)
call npm install --include=dev --no-audit --no-fund --fetch-retries=2 --fetch-timeout=120000
if errorlevel 1 (echo ERRO: npm install falhou. Consulte DIAGNOSTICO_EXECUTAVEL.md. & goto :fail)
call npm run dist:win:installer
if errorlevel 1 (echo ERRO: build NSIS falhou. Consulte DIAGNOSTICO_EXECUTAVEL.md. & goto :fail)
echo.
echo Build concluido. Arquivo esperado:
echo desktop-app\dist\Nexora-ERP-1.3.3-Setup.exe
if exist "%~dp0desktop-app\dist\Nexora-ERP-1.3.3-Setup.exe" explorer "%~dp0desktop-app\dist"
pause
exit /b 0
:fail
echo.
echo Confira a mensagem acima e o arquivo DIAGNOSTICO_EXECUTAVEL.md.
pause
exit /b 1
