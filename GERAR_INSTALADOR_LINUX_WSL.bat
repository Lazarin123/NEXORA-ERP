@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Nexora ERP 1.3.3 - Instalador Linux via WSL2
where wsl.exe >nul 2>nul
if errorlevel 1 (
  echo ERRO: WSL nao foi encontrado.
  echo No PowerShell como administrador, instale uma distribuicao com: wsl --install -d Ubuntu
  pause
  exit /b 1
)
for /f "usebackq delims=" %%P in (`wsl.exe wslpath -a "%~dp0"`) do set "WSL_ROOT=%%P"
if not defined WSL_ROOT (
  echo ERRO: nao consegui converter o caminho para Linux.
  pause
  exit /b 1
)
echo Esta opcao precisa de Node.js e npm instalados DENTRO da distribuicao WSL.
echo Para builds repetidos e mais rapidos, copie o projeto para a pasta Linux ^(~^). Nao misture node_modules de Windows/Linux.
echo.
wsl.exe --cd "%WSL_ROOT%" -- bash -lc "command -v node >/dev/null && command -v npm >/dev/null && chmod +x ./GERAR_INSTALADOR_LINUX.sh && ./GERAR_INSTALADOR_LINUX.sh"
if errorlevel 1 (
  echo.
  echo Build Linux falhou. Confira se Ubuntu/WSL esta instalado e Node.js/npm funcionam dentro dele.
  echo Leia DIAGNOSTICO_EXECUTAVEL.md.
  pause
  exit /b 1
)
echo.
echo Build Linux finalizado. Os pacotes devem estar em desktop-app/dist.
explorer "%~dp0desktop-app\dist"
pause
