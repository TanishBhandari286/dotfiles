#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

echo "🔗 Linking configs to $CONFIG_DIR"

# Link everything from dotfiles/.config to ~/.config
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

echo ""
read -p "🍺 Run 'brew bundle' from Brewfile now? [y/N] " brew_now
if [[ "$brew_now" =~ ^[Yy]$ ]]; then
  brew bundle --file="$HOME/Brewfile"
fi

echo "✨ All done!"
