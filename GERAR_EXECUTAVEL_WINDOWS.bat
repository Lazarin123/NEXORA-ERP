@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Nexora ERP 1.3.3 - EXE portatil Windows x64

echo ============================================================
echo   NEXORA ERP 1.3.3 - EXE PORTATIL WINDOWS x64
echo ============================================================
echo.
where node >nul 2>nul
if errorlevel 1 (echo ERRO: instale Node.js LTS pelo site https://nodejs.org/ & goto :fail)
where npm >nul 2>nul
if errorlevel 1 (echo ERRO: npm nao foi encontrado no PATH. Reinstale Node.js LTS. & goto :fail)
cd /d "%~dp0desktop-app"
if not exist "index.html" (echo ERRO: desktop-app\index.html ausente. Extraia o ZIP inteiro. & goto :fail)
echo Node: & node --version
echo npm: & npm --version
echo.
echo Instalando as dependencias de compilacao. A primeira vez exige internet.
call npm install --include=dev --no-audit --no-fund --fetch-retries=2 --fetch-timeout=120000
if errorlevel 1 (echo ERRO: npm install falhou. Consulte DIAGNOSTICO_EXECUTAVEL.md. & goto :fail)
echo.
echo Gerando EXE portatil...
call npm run dist:win:portable
if errorlevel 1 (echo ERRO: compilacao falhou. Consulte DIAGNOSTICO_EXECUTAVEL.md. & goto :fail)
echo.
echo Build concluido. Arquivo esperado:
echo desktop-app\dist\Nexora-ERP-1.3.3-portable.exe
if exist "%~dp0desktop-app\dist\Nexora-ERP-1.3.3-portable.exe" explorer "%~dp0desktop-app\dist"
pause
exit /b 0
:fail
echo.
echo Confira a mensagem acima e o arquivo DIAGNOSTICO_EXECUTAVEL.md.
pause
exit /b 1
