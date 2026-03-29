#!/bin/bash
set -e

echo "🚀 Starting Full Dotfiles Bootstrap..."

# 1. OS Detection & Tool Installation
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🍎 Detected macOS"
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  brew install chezmoi age eza fzf starship
else
  echo "🐧 Detected Linux (ThinkCentre/VPS)"
  sudo apt update
  sudo apt install -y gpg wget curl git zsh tmux fzf

  # --- Eza Installation (Official Repo) ---
  echo "📦 Setting up eza..."
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update
  sudo apt install -y eza starship

  # Install chezmoi binary (since apt doesn't have it)
  if ! command -v chezmoi &>/dev/null; then
    sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
  fi
fi

# 2. Zsh Plugin Installation (Clone if missing)
echo "🔌 Installing Zsh Plugins..."
PLUGIN_DIR="$HOME/.zsh"
mkdir -p "$PLUGIN_DIR"
[ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR/zsh-autosuggestions"
[ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGIN_DIR/zsh-syntax-highlighting"

# 3. Initialize Chezmoi
# Prompt for age passphrase for SSH keys
chezmoi init --apply --branch main https://github.com/TanishBhandari286/dotfiles.git

# 4. Shell Switch
if [[ "$OSTYPE" != "darwin"* ]]; then
  if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Changing default shell to Zsh..."
    sudo chsh -s $(which zsh) $(whoami)
  fi
fi

echo "✅ All set! Run 'zsh' to enter your new world."
