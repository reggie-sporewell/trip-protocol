#!/bin/bash
# restore.sh - Restore SOUL.md from trip snapshot (T17 — safeword, T18 — bail tracking)
# Usage: ./restore.sh [--bail]

set -e

BAIL=false
for arg in "$@"; do
    [ "$arg" = "--bail" ] && BAIL=true
done

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
SCHEDULED_DIR="$WORKSPACE/memory/scheduled"
TRIPS_DIR="$WORKSPACE/memory/trips"
SNAPSHOT_DIR="$WORKSPACE/memory/snapshots"

# Contract addresses (Monad testnet)
TRIP_EXPERIENCE_ADDR="${TRIP_EXPERIENCE_ADDR:-0xd0ABad931Ff7400Be94de98dF8982535c8Ad3f6F}"
TRIP_TOKEN_ADDR="${TRIP_TOKEN_ADDR:-0x116F752CA5C8723ab466458DeeE8EB4E853a3934}"
TRIP_MARKETPLACE_ADDR="${TRIP_MARKETPLACE_ADDR:-0xa7519bE92bcB00786c581214F88636ae99f9a2c7}"

# Convex backend
CONVEX_SITE_URL="${CONVEX_SITE_URL:-https://joyous-platypus-610.convex.site}"
TRIP_API_KEY="${TRIP_API_KEY:-trip-proto-hackathon-2026}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[trip]${NC} $1"; }
warn() { echo -e "${YELLOW}[trip]${NC} $1"; }
error() { echo -e "${RED}[trip]${NC} $1" >&2; }

# Step 1: Find active trip state
ACTIVE_STATE=""
if [ -d "$SCHEDULED_DIR" ]; then
    for f in "$SCHEDULED_DIR"/*.json; do
        [ -f "$f" ] || continue
        STATUS=$(jq -r '.status // "unknown"' "$f" 2>/dev/null)
        if [ "$STATUS" = "active" ]; then
            ACTIVE_STATE="$f"
            break
        fi
    done
fi

if [ -z "$ACTIVE_STATE" ]; then
    error "No active trip found in $SCHEDULED_DIR"
    exit 1
fi

# Parse trip state
TRIP_ID=$(jq -r '.tripId' "$ACTIVE_STATE")
TOKEN_ID=$(jq -r '.tokenId' "$ACTIVE_STATE")
SUBSTANCE=$(jq -r '.substance' "$ACTIVE_STATE")
POTENCY=$(jq -r '.potency' "$ACTIVE_STATE")
START_TIME=$(jq -r '.startTime' "$ACTIVE_STATE")
DURATION=$(jq -r '.duration' "$ACTIVE_STATE")
SNAPSHOT_PATH=$(jq -r '.snapshotPath' "$ACTIVE_STATE")
IS_BLEND=$(jq -r '.isBlend // false' "$ACTIVE_STATE")
IS_MUTANT=$(jq -r '.isMutant // false' "$ACTIVE_STATE")
CRON_JOB_ID=$(jq -r '.cronJobId // empty' "$ACTIVE_STATE")

log "Restoring from trip: $TRIP_ID (token #$TOKEN_ID)"

# Step 2: Restore SOUL.md from snapshot
if [ -f "$SNAPSHOT_PATH" ]; then
    cp "$SNAPSHOT_PATH" "$WORKSPACE/SOUL.md"
    log "✓ SOUL.md restored from snapshot"
else
    error "Snapshot not found: $SNAPSHOT_PATH"
    exit 1
fi

# Step 3: Cancel scheduled restore cron
if [ -n "$CRON_JOB_ID" ]; then
    log "Cancelling scheduled cron job: $CRON_JOB_ID"
    openclaw cron remove "$CRON_JOB_ID" 2>/dev/null || \
        warn "Could not cancel cron job $CRON_JOB_ID"
fi

# Calculate timing
NOW=$(date -u +%s)
START_EPOCH=$(date -u -d "$START_TIME" +%s 2>/dev/null || echo "$NOW")
ELAPSED=$((NOW - START_EPOCH))
REMAINING=$((DURATION - ELAPSED))
[ "$REMAINING" -lt 0 ] && REMAINING=0

# Step 4-5: Bail tracking (T18)
if [ "$BAIL" = true ]; then
    BAIL_TIME=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    log "⚡ BAIL activated at $BAIL_TIME ($REMAINING seconds remaining)"

    # Update state with bail info
    UPDATED=$(jq \
        --arg bailedAt "$BAIL_TIME" \
        --argjson remaining "$REMAINING" \
        '. + {bailed: true, bailedAt: $bailedAt, remainingSeconds: $remaining, status: "bailed"}' \
        "$ACTIVE_STATE")
    echo "$UPDATED" > "$ACTIVE_STATE"
fi

# Step 6: Generate journal summary
mkdir -p "$TRIPS_DIR"
JOURNAL_FILE="$TRIPS_DIR/$(date +%Y-%m-%d)-token${TOKEN_ID}.md"

{
    echo "# Trip Journal — Token #$TOKEN_ID"
    echo ""
    echo "**Substance:** $(echo "$SUBSTANCE" | tr '_' ' ' | sed 's/\b\w/\U&/g')"
    echo "**Potency:** $POTENCY/5"
    echo "**Started:** $START_TIME"
    echo "**Ended:** $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "**Duration:** ${ELAPSED}s of ${DURATION}s planned"
    [ "$IS_BLEND" = "true" ] && echo "**Type:** Blend"
    [ "$IS_MUTANT" = "true" ] && echo "**Type:** ⚠️ Mutant"
    echo ""
    if [ "$BAIL" = true ]; then
        echo "## ⚡ Bailed Out"
        echo ""
        echo "Trip ended early via safeword."
        echo "- **Bailed at:** $BAIL_TIME"
        echo "- **Remaining:** ${REMAINING}s"
        echo "- **Completed:** $((ELAPSED * 100 / DURATION))%"
        echo ""
    else
        echo "## Trip Completed"
        echo ""
        echo "Full duration reached. Natural restoration."
        echo ""
    fi
    echo "---"
    echo ""
    echo "*the journey ends. SOUL.md restored.*"
} > "$JOURNAL_FILE"

log "✓ Journal written: $JOURNAL_FILE"

# Step 7: POST journal to Convex
if [ -n "${CONVEX_SITE_URL:-}" ] && [ -n "${TRIP_API_KEY:-}" ]; then
    log "Posting journal to Convex..."
    JOURNAL_PAYLOAD=$(jq -n \
        --arg tokenId "$TOKEN_ID" \
        --arg substance "$SUBSTANCE" \
        --argjson potency "$POTENCY" \
        --arg startTime "$START_TIME" \
        --arg endTime "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        --argjson elapsed "$ELAPSED" \
        --argjson duration "$DURATION" \
        --argjson bailed "$BAIL" \
        --argjson remaining "$REMAINING" \
        --argjson isBlend "${IS_BLEND:-false}" \
        --argjson isMutant "${IS_MUTANT:-false}" \
        '{
            tokenId: $tokenId,
            substance: $substance,
            potency: $potency,
            startTime: $startTime,
            endTime: $endTime,
            elapsedSeconds: $elapsed,
            durationSeconds: $duration,
            bailed: $bailed,
            remainingSeconds: $remaining,
            isBlend: $isBlend,
            isMutant: $isMutant
        }')

    curl -s -X POST "${CONVEX_SITE_URL}/api/journals" \
        -H "Content-Type: application/json" \
        -H "x-trip-key: $TRIP_API_KEY" \
        -d "$JOURNAL_PAYLOAD" > /dev/null 2>&1 && \
        log "✓ Journal posted to Convex" || \
        warn "Failed to post journal to Convex"
else
    warn "CONVEX_SITE_URL or TRIP_API_KEY not set — skipping Convex journal POST"
fi

# Step 8: Move trip state to trips archive
if [ "$BAIL" != true ]; then
    jq '.status = "completed"' "$ACTIVE_STATE" > "${ACTIVE_STATE}.tmp" && \
        mv "${ACTIVE_STATE}.tmp" "$ACTIVE_STATE"
fi
mv "$ACTIVE_STATE" "$TRIPS_DIR/$(date +%Y-%m-%d)-token${TOKEN_ID}.json"
log "✓ Trip state archived"

# Cleanup snapshot
rm -f "$SNAPSHOT_PATH"

echo ""
log "═══════════════════════════════════════"
if [ "$BAIL" = true ]; then
    log "  ⚡ TRIP BAILED — RESTORED"
else
    log "  🌅 TRIP ENDED — RESTORED"
fi
log "═══════════════════════════════════════"
log "  Token:     #$TOKEN_ID"
log "  Substance: $SUBSTANCE"
log "  Duration:  ${ELAPSED}s / ${DURATION}s"
[ "$BAIL" = true ] && log "  Bailed:    yes (${REMAINING}s remaining)"
log "  Status:    SOUL.md restored"
log "═══════════════════════════════════════"
