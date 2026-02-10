#!/bin/bash
# schedule-restore.sh - Schedule auto-restore via Clawdbot cron
# Usage: ./schedule-restore.sh <snapshot-id> <duration-seconds> <token-id>
#
# This creates a one-shot cron job that fires after the trip duration,
# triggering the restore and marking the NFT as consumed on-chain.

set -e

SNAPSHOT_ID="${1:-}"
DURATION="${2:-}"
TOKEN_ID="${3:-}"

SKILL_DIR="$(dirname "$0")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[trip]${NC} $1"; }
warn() { echo -e "${YELLOW}[trip]${NC} $1"; }
error() { echo -e "${RED}[trip]${NC} $1" >&2; }

# Validate inputs
if [ -z "$SNAPSHOT_ID" ] || [ -z "$DURATION" ] || [ -z "$TOKEN_ID" ]; then
    error "Usage: schedule-restore.sh <snapshot-id> <duration-seconds> <token-id>"
    exit 1
fi

# Cap duration at 72 hours (259200 seconds)
MAX_DURATION=259200
if [ "$DURATION" -gt "$MAX_DURATION" ]; then
    warn "Duration $DURATION exceeds max (72h). Capping at $MAX_DURATION seconds."
    DURATION=$MAX_DURATION
fi

# Calculate restore time
RESTORE_TIME=$(date -u -d "+${DURATION} seconds" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || \
               date -u -v+${DURATION}S +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || \
               echo "")

if [ -z "$RESTORE_TIME" ]; then
    error "Could not calculate restore time"
    exit 1
fi

log "Scheduling restore for: $RESTORE_TIME"

# Create the restore command
# This will be executed by Clawdbot cron when the time comes
RESTORE_CMD="Trip #$TOKEN_ID has ended. Run: cd $SKILL_DIR && ./restore.sh $SNAPSHOT_ID"

# Write cron job file for Clawdbot to pick up
# Format: JSON with trigger time and command
CRON_DIR="${WORKSPACE:-$HOME/.openclaw/workspace}/memory/scheduled"
mkdir -p "$CRON_DIR"

CRON_FILE="$CRON_DIR/trip-restore-token$TOKEN_ID.json"

cat > "$CRON_FILE" << EOF
{
  "id": "trip-restore-$TOKEN_ID",
  "type": "one-shot",
  "triggerAt": "$RESTORE_TIME",
  "snapshotId": "$SNAPSHOT_ID",
  "tokenId": $TOKEN_ID,
  "command": "restore",
  "skillDir": "$SKILL_DIR",
  "createdAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "pending"
}
EOF

log "✓ Restore scheduled: $CRON_FILE"

# Also output Clawdbot cron command for manual setup if needed
echo ""
log "To manually add to Clawdbot cron, use:"
echo "  clawdbot cron add --at '$RESTORE_TIME' --text '$RESTORE_CMD'"
echo ""

# Output for integration
echo "SCHEDULED_RESTORE_TIME=$RESTORE_TIME"
echo "SCHEDULED_CRON_FILE=$CRON_FILE"
