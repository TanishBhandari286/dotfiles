#!/bin/bash

echo "🔧 Running Post-Install Fixes..."

# 1. Optional: Decrypt SSH keys (Only for Tanish's repo)
if [ -f "$HOME/.ssh/id_ed25519.age" ]; then
  echo "🔓 Found encrypted SSH key. Decrypting..."
  age --decrypt -o "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ed25519.age"
  
  # 2. Fix Permissions
  echo "🔒 Setting 600 permissions on private key..."
  chmod 600 "$HOME/.ssh/id_ed25519"
  chmod 644 "$HOME/.ssh/id_ed25519.pub"
  
  # 3. Add Key to Agent
  echo "🔑 Adding key to SSH agent..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519"
  else
    ssh-add "$HOME/.ssh/id_ed25519"
  fi
else
  echo "⏭️  No encrypted SSH keys found. Skipping key decryption."
fi

# 4. Optional: Configure Git (Ask user or use defaults)
if git config --global user.email &>/dev/null; then
  echo "✅ Git user already configured: $(git config --global user.name) <$(git config --global user.email)>"
else
  echo "📝 Git user not configured. Setting defaults..."
  # Use environment variables if set, otherwise prompt
  GIT_EMAIL="${GIT_EMAIL:-tanishbhandari91@gmail.com}"
  GIT_NAME="${GIT_NAME:-Tanish Bhandari}"
  
  git config --global user.email "$GIT_EMAIL"
  git config --global user.name "$GIT_NAME"
  echo "✅ Git configured: $GIT_NAME <$GIT_EMAIL>"
fi

echo "✅ Post-install complete!"
