#!/bin/bash
set -e

echo "🚀 Starting Dotfiles Bootstrap..."

# 1. OS Detection & Dependency Install
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🍎 Detected macOS"
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  brew install chezmoi age
else
  echo "🐧 Detected Linux (ThinkCentre/VPS)"
  # Install dependencies first
  sudo apt update && sudo apt install -y age curl git zsh tmux

  # Install chezmoi binary to /usr/local/bin
  if ! command -v chezmoi &>/dev/null; then
    echo "Installing chezmoi binary..."
    sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
  fi
fi

# 2. Initialize Chezmoi
# This will prompt for your 'age' passphrase
chezmoi init --apply --branch main https://github.com/TanishBhandari286/dotfiles.git

# 3. Post-Install: Shell & Mac-specifics
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "📦 Installing Mac-specific apps..."
  brew bundle --file ~/.local/share/chezmoi/Brewfile
else
  # Change shell to Zsh if it's not already
  if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Changing default shell to Zsh... (Enter your Linux password)"
    sudo chsh -s $(which zsh) $(whoami)
  fi
fi

echo "✅ All set! Run 'zsh' or log out/in to see your new environment."
