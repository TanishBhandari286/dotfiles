# Tanish's Unified Dotfiles

**Personal setup for Mac M2, ThinkCentre cluster, and Hostinger VPS.**

## Quick Start (Personal)

```bash
/bin/bash -c "$(curl -fsSL "https://raw.githubusercontent.com/TanishBhandari286/dotfiles/main/install.sh?v=$(date +%s)")"
./post-install.sh
```

## Auto-Update (Keep All Machines in Sync)

After installation, enable auto-updates on each machine:

```bash
~/.local/share/chezmoi/setup-autoupdate.sh daily
```

Now every change you push to GitHub is automatically applied to all machines! 🔄

See [AUTO_UPDATE.md](AUTO_UPDATE.md) for details.

## For Friends

Want a similar setup? See [FRIEND_SETUP.md](FRIEND_SETUP.md) for step-by-step instructions to fork and customize this repo.

## Architecture

Uses Homebrew on both macOS and Linux for identical tool versions everywhere.
