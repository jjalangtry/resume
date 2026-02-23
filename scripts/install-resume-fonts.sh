#!/usr/bin/env bash
set -euo pipefail

echo "Checking resume font dependencies..."

if command -v fc-list >/dev/null 2>&1 && fc-list 2>/dev/null | grep -iq "Times New Roman"; then
  echo "Times New Roman already installed."
  exit 0
fi

if [[ "${CI:-}" == "true" ]] && command -v apt-get >/dev/null 2>&1; then
  echo "Installing Times New Roman via msttcorefonts (CI)..."
  sudo apt-get update
  echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
  sudo apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer
  rm -rf "$HOME/.cache/fontconfig" "$HOME/.fontconfig" || true
  fc-cache -f || true
  if fc-list 2>/dev/null | grep -iq "Times New Roman"; then
    echo "Times New Roman installed successfully."
    exit 0
  fi
fi

if [[ "$OSTYPE" == darwin* ]]; then
  echo "Times New Roman install is managed by macOS/Microsoft Office."
  echo "Continuing: resume.tex falls back to TeX Gyre Termes automatically."
  exit 0
fi

echo "Times New Roman not available on this machine."
echo "Continuing: resume.tex falls back to TeX Gyre Termes automatically."
