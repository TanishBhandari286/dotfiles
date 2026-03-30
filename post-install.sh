#!/bin/bash

echo "🔧 Running Post-Install Fixes..."

# 1. Decrypt the key (Matching your actual filename: id_ed25519.age)
if [ -f "$HOME/.ssh/id_ed25519.age" ]; then
  echo "🔓 Decrypting your private key..."
  age --decrypt -o "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ed25519.age"
else
  echo "❌ Error: id_ed25519.age not found in ~/.ssh/"
  exit 1
fi

# 2. Fix Permissions
if [ -f "$HOME/.ssh/id_ed25519" ]; then
  echo "🔒 Setting 600 permissions on private key..."
  chmod 600 "$HOME/.ssh/id_ed25519"
  chmod 644 "$HOME/.ssh/id_ed25519.pub"
fi

# 3. Fix Git Remote (Using the correct 'git --' syntax)
echo "🌐 Switching Chezmoi source to SSH remote..."
chezmoi git -- remote set-url origin git@github.com:TanishBhandari286/dotfiles.git

# 4. Add Key to Agent
echo "🔑 Adding key to SSH agent..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519"
else
  ssh-add "$HOME/.ssh/id_ed25519"
fi

echo "✅ All fixed!"
