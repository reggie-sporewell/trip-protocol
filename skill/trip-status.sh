#!/bin/bash
# trip-status.sh - Check current trip status
# Usage: ./trip-status.sh

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${GREEN}[trip]${NC} $1"; }

# Check if SOUL.md has active trip marker
if [ -f "$WORKSPACE/SOUL.md" ]; then
    if grep -q "🍄 Active Trip" "$WORKSPACE/SOUL.md"; then
        echo ""
        echo -e "${CYAN}═══════════════════════════════════════${NC}"
        echo -e "${CYAN}  🍄 TRIP ACTIVE${NC}"
        echo -e "${CYAN}═══════════════════════════════════════${NC}"
        
        # Extract trip info from SOUL.md
        TRIP_LINE=$(grep -A3 "🍄 Active Trip" "$WORKSPACE/SOUL.md")
        echo "$TRIP_LINE" | head -5
        
        echo -e "${CYAN}═══════════════════════════════════════${NC}"
        echo ""
        echo "To restore early: ./restore.sh"
    else
        echo ""
        log "No active trip."
        echo ""
        
        # Check for recent journals
        JOURNAL_DIR="$WORKSPACE/memory/trips"
        if [ -d "$JOURNAL_DIR" ]; then
            LATEST=$(ls -t "$JOURNAL_DIR"/*.md 2>/dev/null | head -1)
            if [ -n "$LATEST" ]; then
                log "Most recent trip: $(basename "$LATEST")"
            fi
        fi
    fi
else
    log "No SOUL.md found at $WORKSPACE/SOUL.md"
fi
