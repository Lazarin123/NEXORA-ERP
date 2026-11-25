#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$ROOT/desktop-app"

printf '\n============================================================\n'
printf ' NEXORA ERP 1.3.3 - PACOTES LINUX x64\n'
printf ' Saidas: AppImage (portatil) e DEB (Ubuntu/Debian/Mint)\n'
printf '============================================================\n\n'

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "ERRO: este script deve ser executado no Linux (ou em uma distro WSL2)."
  echo "No Windows, use GERAR_INSTALADOR_WINDOWS.bat para criar o instalador Windows."
  exit 1
fi
command -v node >/dev/null 2>&1 || { echo "ERRO: Node.js nao encontrado. Instale uma versao LTS (20 ou superior)."; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "ERRO: npm nao encontrado. Instale Node.js com npm."; exit 1; }
node -e 'process.exit(Number(process.versions.node.split(".")[0]) >= 20 ? 0 : 1)' || { echo "ERRO: use Node.js 20 ou superior."; exit 1; }
[[ -f "$APP_DIR/index.html" && -f "$APP_DIR/package.json" ]] || { echo "ERRO: estrutura desktop-app incompleta; extraia o ZIP completo."; exit 1; }

cd "$APP_DIR"
# Evita reutilizar módulos nativos/runtime baixados para outro sistema operacional.
if [[ -d node_modules ]]; then
  echo "Removendo node_modules anterior para evitar mistura Windows/Linux..."
  rm -rf node_modules
fi

echo "Instalando dependencias de compilacao (a primeira vez requer internet)..."
npm install --include=dev --no-audit --no-fund --fetch-retries=2 --fetch-timeout=120000

echo "Gerando AppImage e pacote DEB..."
npm run dist:linux

echo
printf 'Pacotes gerados em: %s\n' "$APP_DIR/dist"
find "$APP_DIR/dist" -maxdepth 1 -type f \( -iname '*.AppImage' -o -iname '*.deb' \) -printf '%f  %k KB\n' | sort
