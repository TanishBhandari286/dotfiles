#!/bin/bash
set -e

# 1. Detect OS & Install Dependencies
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🍎 Mac M2 detected"
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  brew install chezmoi age
else
  echo "🐧 Linux (ThinkCentre/VPS) detected"
  sudo apt update && sudo apt install -y chezmoi age curl git
fi

# 2. Initialize and Apply
# This clones your repo and places .zshrc in ~/ automatically
chezmoi init --apply --branch main https://github.com/TanishBhandari286/dotfiles.git

# 3. Post-install for Mac
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "📦 Bundling Homebrew apps..."
  brew bundle --file ~/.local/share/chezmoi/Brewfile
fi

echo "✨ Done! Restart your terminal."
