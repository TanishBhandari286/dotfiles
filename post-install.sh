#!/bin/bash

echo "🔧 Running Post-Install Fixes..."

# 1. Fix SSH Permissions
if [ -f "$HOME/.ssh/id_ed25519" ]; then
  echo "🔒 Setting 600 permissions on private key..."
  chmod 600 "$HOME/.ssh/id_ed25519"
  chmod 644 "$HOME/.ssh/id_ed25519.pub"
else
  echo "❌ Private key not found. Did you run the age decrypt command?"
fi

# 2. Fix Git Remote (Switch from HTTPS to SSH)
echo "🌐 Switching Chezmoi source to SSH remote..."
# This command goes into the hidden chezmoi source folder and changes the URL
chezmoi cd -- git remote set-url origin git@github.com:TanishBhandari286/dotfiles.git

# 3. Add Key to Agent (Optional but saves typing)
if [[ "$OSTYPE" == "darwin"* ]]; then
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
else
  ssh-add ~/.ssh/id_ed25519
fi

echo "✅ All fixed! You can now use 'gsync' or 'git push' without issues."
