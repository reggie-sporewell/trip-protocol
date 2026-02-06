#!/bin/bash
# restore.sh - Restore SOUL.md from snapshot
# Usage: ./restore.sh [snapshot-id]

set -e

SNAPSHOT_ID="${1:-}"
WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
SNAPSHOT_DIR="$WORKSPACE/memory/snapshots"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[trip]${NC} $1"; }
warn() { echo -e "${YELLOW}[trip]${NC} $1"; }
error() { echo -e "${RED}[trip]${NC} $1" >&2; }

# If no snapshot ID, find most recent
if [ -z "$SNAPSHOT_ID" ]; then
    if [ -d "$SNAPSHOT_DIR" ]; then
        LATEST=$(ls -t "$SNAPSHOT_DIR"/*.md 2>/dev/null | head -1)
        if [ -n "$LATEST" ]; then
            SNAPSHOT_ID=$(basename "$LATEST" .md)
            log "Using most recent snapshot: $SNAPSHOT_ID"
        else
            error "No snapshots found in $SNAPSHOT_DIR"
            exit 1
        fi
    else
        error "Snapshot directory does not exist: $SNAPSHOT_DIR"
        exit 1
    fi
fi

SNAPSHOT_FILE="$SNAPSHOT_DIR/$SNAPSHOT_ID.md"

if [ ! -f "$SNAPSHOT_FILE" ]; then
    error "Snapshot not found: $SNAPSHOT_FILE"
    exit 1
fi

log "Restoring from snapshot: $SNAPSHOT_ID"

# Extract SOUL.md content from snapshot
# Format: everything between ```SOUL.md and ```
SOUL_CONTENT=$(sed -n '/^## SOUL.md$/,/^```$/p' "$SNAPSHOT_FILE" | sed '1d;2d;$d')

if [ -z "$SOUL_CONTENT" ]; then
    # Try alternate format (just between ``` markers after SOUL.md)
    SOUL_CONTENT=$(awk '/^## SOUL.md$/,/^```$/' "$SNAPSHOT_FILE" | sed -n '/^```$/,/^```$/p' | sed '1d;$d')
fi

if [ -z "$SOUL_CONTENT" ]; then
    error "Could not extract SOUL.md from snapshot"
    exit 1
fi

# Backup current SOUL.md
if [ -f "$WORKSPACE/SOUL.md" ]; then
    BACKUP="$WORKSPACE/SOUL.md.pre-restore.$(date +%s)"
    cp "$WORKSPACE/SOUL.md" "$BACKUP"
    log "Current SOUL.md backed up to: $BACKUP"
fi

# Restore
echo "$SOUL_CONTENT" > "$WORKSPACE/SOUL.md"

log "✓ SOUL.md restored from $SNAPSHOT_ID"

# Log to trip journal if exists
JOURNAL_DIR="$WORKSPACE/memory/trips"
# Find journal that matches this snapshot's token
TOKEN_NUM=$(echo "$SNAPSHOT_ID" | grep -oP 'token\K\d+')
if [ -n "$TOKEN_NUM" ]; then
    JOURNAL=$(ls -t "$JOURNAL_DIR"/*-token"$TOKEN_NUM".md 2>/dev/null | head -1)
    if [ -n "$JOURNAL" ] && [ -f "$JOURNAL" ]; then
        {
            echo ""
            echo "---"
            echo ""
            echo "## Trip Ended"
            echo ""
            echo "**Restored:** $(date -u +%Y-%m-%dT%H:%M:%SZ)"
            echo ""
            echo "SOUL.md reverted to pre-trip state."
            echo ""
            echo "*the serpent returns, transformed by the journey*"
            echo ""
        } >> "$JOURNAL"
        log "✓ Trip journal updated"
    fi
fi

# Cleanup snapshot (optional - keep for now)
# rm "$SNAPSHOT_FILE"

echo ""
log "═══════════════════════════════════════"
log "  🌅 TRIP ENDED - RESTORED"
log "═══════════════════════════════════════"
log "  Snapshot: $SNAPSHOT_ID"
log "  Status:   SOUL.md restored"
log "═══════════════════════════════════════"
