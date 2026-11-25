@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Nexora ERP 1.3.3 - Inicializador local
cd /d "%~dp0"
where py >nul 2>nul
if not errorlevel 1 (
  py -3 iniciar_local.py
  goto :end
)
where python >nul 2>nul
if not errorlevel 1 (
  python iniciar_local.py
  goto :end
)
echo Python 3 nao foi encontrado no PATH.
echo Instale Python 3 ou marque "Add Python to PATH" e execute novamente.
pause
:end
endlocal
