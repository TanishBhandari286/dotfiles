#!/bin/bash

echo "🔧 Running Post-Install Fixes..."

# 1. Decrypt the key first
if [ -f "$HOME/.ssh/encrypted_id_ed25519.age" ]; then
  echo "🔓 Decrypting your private key..."
  # This will prompt for your passphrase
  age --decrypt -o "$HOME/.ssh/id_ed25519" "$HOME/.ssh/encrypted_id_ed25519.age"
else
  echo "❌ Error: encrypted_id_ed25519.age not found in ~/.ssh/"
  exit 1
fi

# 2. Fix Permissions (Only if decryption worked)
if [ -f "$HOME/.ssh/id_ed25519" ]; then
  echo "🔒 Setting 600 permissions on private key..."
  chmod 600 "$HOME/.ssh/id_ed25519"
  chmod 644 "$HOME/.ssh/id_ed25519.pub"
fi

# 3. Fix Git Remote (The correct Chezmoi syntax)
echo "🌐 Switching Chezmoi source to SSH remote..."
# 'chezmoi git --' runs the command directly in the source repo
chezmoi git -- remote set-url origin git@github.com:TanishBhandari286/dotfiles.git

# 4. Add Key to Agent
echo "🔑 Adding key to SSH agent..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac-specific: saves the passphrase to your keychain
  ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519"
else
  ssh-add "$HOME/.ssh/id_ed25519"
fi

echo "✅ All fixed! You can now use 'gsync' or 'git push' without issues."
