#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FONTS_DIR="$SCRIPT_DIR/../latex/fonts"

echo "Checking resume font dependencies..."

copy_times_to_workspace() {
  echo "Locating Times New Roman TTFs to stage for Docker build..."
  local found=0
  for name in Times.TTF Timesbd.TTF Timesi.TTF Timesbi.TTF; do
    local path
    path=$(find /usr/share/fonts -iname "$name" -print -quit 2>/dev/null || true)
    if [[ -n "$path" ]]; then
      cp "$path" "$FONTS_DIR/"
      found=1
    fi
  done
  if [[ "$found" -eq 1 ]]; then
    echo "Font files staged in latex/fonts/:"
    ls "$FONTS_DIR"/Times*.TTF "$FONTS_DIR"/times*.ttf 2>/dev/null || true
  else
    echo "Warning: could not locate Times TTF files to stage."
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
