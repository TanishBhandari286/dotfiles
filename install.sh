#!/bin/bash
set -e

echo "🚀 Starting Dotfiles Bootstrap..."

# 1. OS Detection & Dependency Install
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🍎 Detected macOS (M2 Air)"
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  # Mac already has Zsh, so we just need the tools
  brew install chezmoi age starship
else
  echo "🐧 Detected Linux (ThinkCentre/VPS)"
  # We explicitly add 'zsh' to the apt install list
  sudo apt update && sudo apt install -y chezmoi age curl git zsh tmux
fi

# 2. Initialize Chezmoi
# It will prompt for your 'age' passphrase for the SSH keys
chezmoi init --apply --branch main https://github.com/TanishBhandari286/dotfiles.git

# 3. Post-Install: Shell & Mac-specifics
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "📦 Installing Mac-specific apps..."
  brew bundle --file ~/.local/share/chezmoi/Brewfile
else
  # Automatically change shell to zsh on Linux if it's not already set
  if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Changing default shell to Zsh..."
    chsh -s $(which zsh)
  fi
fi

echo "✅ All set! Log out and back in (or run 'zsh') to see the magic."
