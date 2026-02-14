#!/bin/bash
# schedule-restore.sh - Schedule auto-restore via OpenClaw cron
# Usage: ./schedule-restore.sh <trip-id> <duration-seconds> <token-id>

set -e

TRIP_ID="${1:-}"
DURATION="${2:-}"
TOKEN_ID="${3:-}"
SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[trip]${NC} $1"; }
warn() { echo -e "${YELLOW}[trip]${NC} $1"; }
error() { echo -e "${RED}[trip]${NC} $1" >&2; }

if [ -z "$TRIP_ID" ] || [ -z "$DURATION" ] || [ -z "$TOKEN_ID" ]; then
    error "Usage: schedule-restore.sh <trip-id> <duration-seconds> <token-id>"
    exit 1
fi

# Cap at 72h
[ "$DURATION" -gt 259200 ] && DURATION=259200

RESTORE_TIME=$(date -u -d "+${DURATION} seconds" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || \
               date -u -v+${DURATION}S +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo "")

if [ -z "$RESTORE_TIME" ]; then
    error "Could not calculate restore time"
    exit 1
fi

log "Scheduling restore at: $RESTORE_TIME"

# Create OpenClaw cron job
CRON_TEXT="Trip #$TOKEN_ID has ended. Run: cd $SKILL_DIR && ./restore.sh"
CRON_OUTPUT=$(openclaw cron add --at "$RESTORE_TIME" --text "$CRON_TEXT" 2>&1 || echo "")
CRON_JOB_ID=$(echo "$CRON_OUTPUT" | grep -oP 'id[:\s]*\K[a-zA-Z0-9_-]+' | head -1 || echo "")

# Store cron job ID in trip state file
STATE_FILE="$WORKSPACE/memory/scheduled/$TRIP_ID.json"
if [ -n "$CRON_JOB_ID" ] && [ -f "$STATE_FILE" ]; then
    jq --arg cronId "$CRON_JOB_ID" '. + {cronJobId: $cronId}' "$STATE_FILE" > "${STATE_FILE}.tmp" && \
        mv "${STATE_FILE}.tmp" "$STATE_FILE"
    log "✓ Cron job stored: $CRON_JOB_ID"
fi

log "✓ Restore scheduled"
echo "SCHEDULED_RESTORE_TIME=$RESTORE_TIME"
echo "SCHEDULED_CRON_JOB_ID=${CRON_JOB_ID:-none}"
