#!/bin/bash

# Auto-update script for chezmoi
# Runs: git pull + chezmoi apply
# Logs to: ~/.chezmoi-autoupdate.log

LOG_FILE="$HOME/.chezmoi-autoupdate.log"

{
  echo "================ $(date) ================"
  
  # Check if chezmoi is installed
  if ! command -v chezmoi &>/dev/null; then
    echo "❌ chezmoi not found. Skipping update."
    exit 1
  fi
  
  # Pull latest from GitHub
  echo "📥 Pulling latest config..."
  chezmoi git -- pull
  PULL_STATUS=$?
  
  if [ $PULL_STATUS -eq 0 ]; then
    echo "✅ Pull successful"
    
    # Apply changes
    echo "🔄 Applying config..."
    chezmoi apply
    APPLY_STATUS=$?
    
    if [ $APPLY_STATUS -eq 0 ]; then
      echo "✅ Config applied successfully"
    else
      echo "❌ Failed to apply config (exit code: $APPLY_STATUS)"
    fi
  else
    echo "❌ Failed to pull (exit code: $PULL_STATUS)"
  fi
  
  echo "================ Done ================"
  echo ""
  
} >> "$LOG_FILE" 2>&1

exit 0
