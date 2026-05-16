# Auto-Update Setup

Keep all your machines automatically synced with your latest GitHub changes!

## How It Works

1. You make changes on your Mac and push to GitHub
2. Cron job runs periodically on each server
3. Pulls latest config and applies it automatically
4. **Skips encrypted files** (SSH keys) to avoid passphrase prompts
5. Logs all updates for debugging

## Quick Setup

On each machine you want auto-update:

```bash
cd ~/.local/share/chezmoi
chmod +x setup-autoupdate.sh
./setup-autoupdate.sh daily
```

That's it! The job now runs daily at 2 AM.

## Frequency Options

```bash
# Every hour
./setup-autoupdate.sh hourly

# Every 4 hours (recommended for servers)
./setup-autoupdate.sh 4hourly

# Daily at 2 AM (default)
./setup-autoupdate.sh daily
```

## View Cron Job

```bash
crontab -l | grep chezmoi
```

## Check Logs

```bash
tail -f ~/.chezmoi-autoupdate.log
```

Or see all updates:

```bash
cat ~/.chezmoi-autoupdate.log
```

## Manual Update

You can also manually update anytime:

```bash
~/.local/share/chezmoi/auto-update.sh
```

## Remove Auto-Update

```bash
crontab -e
# Delete the line with "chezmoi-autoupdate"
# Save and exit
```

Or use:

```bash
crontab -l | grep -v "chezmoi-autoupdate" | crontab -
```

## Troubleshooting

**Check if cron is running:**
```bash
ps aux | grep cron
```

**Test the script manually:**
```bash
~/.local/share/chezmoi/auto-update.sh
tail ~/.chezmoi-autoupdate.log
```

**View all cron jobs:**
```bash
crontab -l
```

**SSH key issues:** Make sure you ran `post-install.sh` and your SSH key is added to the agent.

## Important Notes

- Auto-update only works if your dotfiles are **pushed to GitHub** and the machine has **SSH access**
- First run `post-install.sh` to set up SSH keys
- The script runs silently (logs to file, no terminal output)
- All updates are logged for debugging
- **Encrypted files (SSH keys) are skipped** by default to avoid passphrase prompts
  - If you want encrypted files synced, set `AGE_PASSPHRASE` environment variable (less secure)

## Encrypted Files During Auto-Update

By default, auto-update **skips encrypted files** (like `dot_ssh/id_ed25519.age`) to avoid blocking on passphrase prompts.

**If you want to sync encrypted files automatically:**

Option A - Set environment variable in crontab:
```bash
crontab -e
# Add to the cron job:
0 2 * * * AGE_PASSPHRASE="your-passphrase" ~/.local/share/chezmoi/auto-update.sh
```

Option B - Use SSH agent (more secure):
```bash
# SSH agent holds your key after post-install.sh
# No passphrase needed for auto-update
```

**Not recommended:** Storing passphrases in crontab is a security risk. It's safer to exclude encrypted files.
