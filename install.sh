#!/bin/bash
set -e

echo "🚀 Starting Unified Dotfiles Bootstrap..."

# 1. Install Homebrew (Logic remains the same...)
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
# We init with HTTPS because it's public and doesn't need a key yet...
chezmoi init --apply --branch main https://github.com/TanishBhandari286/dotfiles.git

# --- AUTO-FIX SECTION ---
echo "🔧 Auto-fixing Git Remote and Permissions..."

# Fix 1: Switch the source repo to SSH so 'gsync' works without passwords
chezmoi cd -- git remote set-url origin git@github.com:TanishBhandari286/dotfiles.git

# Fix 2: Force correct SSH permissions
if [ -f "$HOME/.ssh/id_ed25519" ]; then
  chmod 600 "$HOME/.ssh/id_ed25519"
  chmod 644 "$HOME/.ssh/id_ed25519.pub"
fi
# -------------------------

# 4. Install from Brewfile
echo "📦 Syncing tools from Brewfile..."
brew bundle --file ~/.local/share/chezmoi/Brewfile

# 5. Shell Switch
if [[ "$OSTYPE" != "darwin"* ]]; then
  [ "$SHELL" != "$(which zsh)" ] && sudo chsh -s $(which zsh) $(whoami)
fi

echo "✅ All set! One-liner complete."
