#!/bin/bash
set -e

echo "🚀 Starting Unified Dotfiles Bootstrap..."

# 1. Install Homebrew
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🍎 Mac M2 detected"
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "🐧 Linux detected"
  sudo apt update && sudo apt install -y build-essential procps curl file git zsh age
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# 2. Install Chezmoi
brew install chezmoi

# 3. Apply Dotfiles
chezmoi init --apply --branch main https://github.com/TanishBhandari286/dotfiles.git

# --- AUTO-FIX SECTION ---
echo "🔧 Auto-fixing Git Remote..."
# Using 'git --' instead of 'cd' to avoid argument errors
chezmoi git -- remote set-url origin git@github.com:TanishBhandari286/dotfiles.git

# 4. Install from Brewfile
echo "📦 Syncing tools from Brewfile..."
brew bundle --file ~/.local/share/chezmoi/Brewfile

# 5. Shell Switch
if [[ "$OSTYPE" != "darwin"* ]]; then
  [ "$SHELL" != "$(which zsh)" ] && sudo chsh -s $(which zsh) $(whoami)
fi

echo "✅ One-liner complete. Now run ./post-install.sh to decrypt your keys."
