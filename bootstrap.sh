#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Step 1: Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found, installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed"
fi

# Step 2: Install stow via Homebrew
echo "Installing stow..."
brew install stow

# Step 3: Link configs to $CONFIG_DIR
echo "🔗 Linking configs to $CONFIG_DIR"

cd "$DOTFILES_DIR/.config"

for name in *; do
  src="$DOTFILES_DIR/.config/$name"
  dest="$CONFIG_DIR/$name"

  if [ -L "$dest" ] || [ -e "$dest" ]; then
    echo "⚠️  Skipping $name (already exists)"
  else
    ln -s "$src" "$dest"
    echo "✅ Linked $name"
  fi
done

# Step 4: Link top-level files (like Brewfile) to home directory
echo ""
echo "🔗 Linking top-level files (like Brewfile) to home directory"

cd "$DOTFILES_DIR"
for file in Brewfile; do
  src="$DOTFILES_DIR/$file"
  dest="$HOME/$file"

  if [ -L "$dest" ] || [ -e "$dest" ]; then
    echo "⚠️  Skipping $file (already exists)"
  else
    ln -s "$src" "$dest"
    echo "✅ Linked $file"
  fi
done

# Step 5: Run brew bundle if desired
echo ""
read -p "🍺 Run 'brew bundle' from Brewfile now? [y/N] " brew_now
if [[ "$brew_now" =~ ^[Yy]$ ]]; then
  brew bundle --file="$HOME/Brewfile"
fi

echo "✨ All done!"
