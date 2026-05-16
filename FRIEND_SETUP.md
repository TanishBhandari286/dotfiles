# Setup Guide for Friends

Want a unified dotfiles setup like Tanish's? Fork this repo and follow these steps.

## Step 1: Fork & Clone

```bash
# Fork on GitHub (click Fork button)
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles
```

## Step 2: Customize Brewfile & Configs

Edit what you want:

```bash
# Terminal & CLI tools
nano Brewfile

# Shell settings
nano dot_zshrc.tmpl

# Editor (Neovim)
nano dot_config/nvim/init.lua

# Terminal emulator config (or replace)
nano dot_config/ghostty/config

# Tmux config
nano dot_tmux.conf
```

**Remove what you don't need:**
```bash
rm -rf dot_config/aerospace/  # Mac window manager (remove on Linux)
rm -rf dot_ssh/               # You'll add your own SSH keys later
```

## Step 3: Update Installation Scripts

Replace `TanishBhandari286` with your GitHub username:

```bash
sed -i 's/TanishBhandari286/YOUR_USERNAME/g' install.sh post-install.sh
```

## Step 4: Update Git Config

Edit `post-install.sh` and change:

```bash
GIT_EMAIL="your-email@example.com"
GIT_NAME="Your Name"
```

## Step 5: Add SSH Keys (Optional but Recommended)

### Option A: Simple SSH Key (No Encryption)

```bash
# Generate SSH key
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

# Add public key to GitHub Settings > SSH and GPG keys

# Copy to repo
cp ~/.ssh/id_ed25519.pub dot_ssh/
cp ~/.ssh/id_ed25519 dot_ssh/
```

Then update `post-install.sh` to add the key to SSH agent.

### Option B: Encrypted SSH Key with Age (Recommended)

```bash
# Generate SSH key
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

# Install age
brew install age

# Create a passphrase and encrypt the key
age --encrypt --output ~/.ssh/id_ed25519.age -p ~/.ssh/id_ed25519

# Copy encrypted key to repo
cp ~/.ssh/id_ed25519.age dot_ssh/
cp ~/.ssh/id_ed25519.pub dot_ssh/

# Remove unencrypted key (keep encrypted version only)
rm ~/.ssh/id_ed25519

# Add public key to GitHub
cat dot_ssh/id_ed25519.pub
# Copy output to GitHub Settings > SSH and GPG keys
```

**Update `post-install.sh`:**

The script already handles this! It will:
1. Ask for your age passphrase
2. Decrypt the key
3. Set proper permissions
4. Add to SSH agent

You just need to have the passphrase ready when running `./post-install.sh`.

## Step 6: Commit & Push

```bash
git add .
git commit -m "Customize for my setup"
git push
```

## Step 7: Enable Auto-Updates (Optional)

Keep your machines automatically synced with your GitHub changes:

```bash
~/.local/share/chezmoi/setup-autoupdate.sh daily
```

This runs daily at 2 AM. Options:
- `hourly` - Check every hour
- `4hourly` - Check every 4 hours  
- `daily` - Check daily at 2 AM (default)

Now all your machines stay in sync automatically! 🔄

See [AUTO_UPDATE.md](AUTO_UPDATE.md) for more details.

## Step 8: Test on a Fresh Machine

### Full Installation (One-Liner)

```bash
/bin/bash -c "$(curl -fsSL "https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh?v=$(date +%s)")"
```

This will:
- ✅ Install Homebrew
- ✅ Install chezmoi
- ✅ Clone your dotfiles
- ✅ Install from Brewfile
- ✅ Apply configs

### Post-Install (Git Config & SSH Keys)

```bash
./post-install.sh
```

When prompted:
- Enter your Git email/name (or it uses defaults)
- Enter your age passphrase (if using encrypted SSH keys)

## Step 9: Share with Friends

Your friends can now run:

```bash
/bin/bash -c "$(curl -fsSL "https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh?v=$(date +%s)")"
./post-install.sh
```

Done! They now have your setup. 🎉

---

## Tips

- **No SSH keys**: Skip the SSH setup and just use HTTPS for Git
- **Different terminal**: Replace Ghostty config with your terminal's config
- **Different editor**: Replace Neovim setup with Vim, VS Code, etc.
- **Test locally first**: `chezmoi apply --dry-run` to see what will change
