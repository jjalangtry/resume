#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FONTS_DIR="$SCRIPT_DIR/../latex/fonts"

echo "Checking resume font dependencies..."

copy_times_to_workspace() {
  local src="/usr/share/fonts/truetype/msttcorefonts"
  if [[ -d "$src" ]]; then
    echo "Copying Times New Roman TTFs into latex/fonts/ for Docker build..."
    cp "$src"/Times.TTF "$src"/Timesbd.TTF "$src"/Timesi.TTF "$src"/Timesbi.TTF "$FONTS_DIR/" 2>/dev/null || true
    ls "$FONTS_DIR"/Times*.TTF 2>/dev/null && echo "Font files staged."
  fi
}

if command -v fc-list >/dev/null 2>&1 && fc-list 2>/dev/null | grep -iq "Times New Roman"; then
  echo "Times New Roman already installed."
  copy_times_to_workspace
  exit 0
fi

if command -v apt-get >/dev/null 2>&1; then
  echo "Installing Times New Roman via msttcorefonts..."
  sudo apt-get update -qq
  echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
  sudo apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer
  rm -rf "$HOME/.cache/fontconfig" "$HOME/.fontconfig" 2>/dev/null || true
  fc-cache -f 2>/dev/null || true
  copy_times_to_workspace
  if fc-list 2>/dev/null | grep -iq "Times New Roman"; then
    echo "Times New Roman installed successfully."
    exit 0
  fi
fi

if [[ "$OSTYPE" == darwin* ]]; then
  echo "Times New Roman is available via macOS / Microsoft Office."
  exit 0
fi

echo "Times New Roman not found. LaTeX will fall back to TeX Gyre Termes."
