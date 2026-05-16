#!/bin/bash

# Setup script for auto-update cron job
# Usage: ./setup-autoupdate.sh [frequency]
# Frequency options: hourly, 4hourly, daily (default)

set -e

FREQUENCY="${1:-daily}"
AUTO_UPDATE_SCRIPT="$HOME/.local/share/chezmoi/auto-update.sh"
CRON_ID="chezmoi-autoupdate"

# Validate script exists
if [ ! -f "$AUTO_UPDATE_SCRIPT" ]; then
  echo "❌ Error: auto-update.sh not found at $AUTO_UPDATE_SCRIPT"
  exit 1
fi

# Make it executable
chmod +x "$AUTO_UPDATE_SCRIPT"

# Determine cron schedule
case "$FREQUENCY" in
  hourly)
    SCHEDULE="0 * * * *"
    DESC="every hour"
    ;;
  4hourly)
    SCHEDULE="0 */4 * * *"
    DESC="every 4 hours"
    ;;
  daily)
    SCHEDULE="0 2 * * *"
    DESC="daily at 2 AM"
    ;;
  *)
    echo "❌ Unknown frequency: $FREQUENCY"
    echo "Use: hourly, 4hourly, or daily (default)"
    exit 1
    ;;
esac

# Remove existing cron job if it exists
echo "🧹 Removing any existing auto-update cron jobs..."
(crontab -l 2>/dev/null | grep -v "$CRON_ID" | crontab -) 2>/dev/null || true

# Add new cron job
echo "➕ Adding cron job ($DESC)..."
CRON_JOB="$SCHEDULE $AUTO_UPDATE_SCRIPT # $CRON_ID"
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

echo "✅ Auto-update enabled!"
echo "📅 Schedule: $DESC"
echo "📋 Check logs: tail -f ~/.chezmoi-autoupdate.log"
echo ""
echo "View cron job:"
crontab -l | grep chezmoi-autoupdate || echo "No cron job found"
