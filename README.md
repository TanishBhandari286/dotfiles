# Tanish's Unified Dotfiles

# ⚠️ STOP: READ THIS BEFORE PROCEEDING ⚠️

## DO NOT RUN THE ONE-LINER BELOW ON YOUR OWN MACHINE.

### YOU DO NOT HAVE THE AGE PASSPHRASE FOR MY SSH KEYS. THE DECRYPTION WILL FAIL, AND THE INSTALLATION WILL EXIT. THIS REPO IS FOR MY PERSONAL USE ACROSS MY MACBOOK AIR M2, THINKCENTRE CLUSTER (NODE-1/2/3), AND HOSTINGER VPS.

## The One-Liner

- This command bootstraps a fresh environment from zero. It installs Homebrew (Mac or Linux), sets up Zsh, pulls this repository, decrypts my private keys, and installs all tools from the Brewfile.

```bash
/bin/bash -c "$(curl -fsSL "https://raw.githubusercontent.com/TanishBhandari286/dotfiles/main/install.sh?v=$(date +%s)")"


```

## Architecture: Unified Homebrew

### This setup treats macOS and Linux as equals by using Homebrew for Linux. This ensures that my versions of Neovim, Lazygit, and Eza are identical whether I'm on my M2 Mac or a refurbished ThinkCentre.
