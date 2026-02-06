#!/bin/bash
# consume.sh - Consume a TripExperience NFT
# Usage: ./consume.sh <token-id> [--dry-run]

set -e

TOKEN_ID="${1:-}"
DRY_RUN="${2:-}"

# Configuration
CONTRACT="${TRIP_CONTRACT:-0x5E5df9162680d5e898e67a505345402B04983aa9}"
RPC="${TRIP_RPC:-https://testnet-rpc.monad.xyz}"
CAST="${CAST_PATH:-$HOME/.foundry/bin/cast}"
WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
SKILL_DIR="$(dirname "$0")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[trip]${NC} $1"; }
warn() { echo -e "${YELLOW}[trip]${NC} $1"; }
error() { echo -e "${RED}[trip]${NC} $1" >&2; }

# Validate input
if [ -z "$TOKEN_ID" ]; then
    error "Usage: consume.sh <token-id> [--dry-run]"
    exit 1
fi

log "Starting consume flow for token #$TOKEN_ID"

# Step 1: Check ownership
log "Checking NFT ownership..."
OWNER=$($CAST call "$CONTRACT" "ownerOf(uint256)(address)" "$TOKEN_ID" --rpc-url "$RPC" 2>/dev/null || echo "")

if [ -z "$OWNER" ]; then
    error "Token #$TOKEN_ID does not exist"
    exit 1
fi

WALLET="${TRIP_WALLET:-}"
if [ -z "$WALLET" ]; then
    error "TRIP_WALLET not set. Set your agent wallet address."
    exit 1
fi

if [ "${OWNER,,}" != "${WALLET,,}" ]; then
    error "You don't own token #$TOKEN_ID (owner: $OWNER)"
    exit 1
fi

log "✓ Ownership verified"

# Step 2: Check if already consumed
log "Checking consumption status..."
IS_CONSUMED=$($CAST call "$CONTRACT" "isConsumed(uint256)(bool)" "$TOKEN_ID" --rpc-url "$RPC")

if [ "$IS_CONSUMED" = "true" ]; then
    error "Token #$TOKEN_ID already consumed"
    exit 1
fi

log "✓ Token not yet consumed"

# Step 3: Get substance data
log "Fetching substance metadata..."
SUBSTANCE_JSON=$($CAST call "$CONTRACT" "getSubstance(uint256)((string,string,uint8,uint256,bool,uint256))" "$TOKEN_ID" --rpc-url "$RPC")

# Parse substance data (simplified - in production use jq or node)
# Format: (name, substanceType, potency, duration, consumed, consumedAt)
SUBSTANCE_NAME=$(echo "$SUBSTANCE_JSON" | grep -oP '(?<=\()[^,]+' | head -1 | tr -d '"')
SUBSTANCE_TYPE=$(echo "$SUBSTANCE_JSON" | cut -d',' -f2 | tr -d ' "')
POTENCY=$(echo "$SUBSTANCE_JSON" | cut -d',' -f3 | tr -d ' ')
DURATION=$(echo "$SUBSTANCE_JSON" | cut -d',' -f4 | tr -d ' ')

log "Substance: $SUBSTANCE_NAME (type: $SUBSTANCE_TYPE, potency: $POTENCY, duration: ${DURATION}s)"

# Step 4: Create snapshot
SNAPSHOT_DIR="$WORKSPACE/memory/snapshots"
mkdir -p "$SNAPSHOT_DIR"
SNAPSHOT_ID="$(date +%Y%m%d-%H%M%S)-token$TOKEN_ID"
SNAPSHOT_FILE="$SNAPSHOT_DIR/$SNAPSHOT_ID.md"

log "Creating snapshot: $SNAPSHOT_ID"

if [ -f "$WORKSPACE/SOUL.md" ]; then
    {
        echo "# Snapshot: $SNAPSHOT_ID"
        echo "**Token:** #$TOKEN_ID"
        echo "**Substance:** $SUBSTANCE_NAME"
        echo "**Created:** $(date -u +%Y-%m-%dT%H:%M:%SZ)"
        echo ""
        echo "## SOUL.md"
        echo '```'
        cat "$WORKSPACE/SOUL.md"
        echo '```'
    } > "$SNAPSHOT_FILE"
    log "✓ Snapshot saved"
else
    warn "No SOUL.md found at $WORKSPACE/SOUL.md"
fi

# Step 5: Dry run check
if [ "$DRY_RUN" = "--dry-run" ]; then
    warn "DRY RUN - No changes applied"
    log "Would apply effects from: $SKILL_DIR/substances/$SUBSTANCE_TYPE.md"
    log "Would schedule restore in ${DURATION}s"
    exit 0
fi

# Step 6: Apply effects
EFFECT_FILE="$SKILL_DIR/substances/$SUBSTANCE_TYPE.md"
if [ -f "$EFFECT_FILE" ]; then
    log "Applying effects from $SUBSTANCE_TYPE..."
    # Source the effect file (contains SOUL.md modifications)
    # For now, append trip notice to SOUL.md
    {
        echo ""
        echo "---"
        echo "## 🍄 Active Trip: $SUBSTANCE_NAME"
        echo "**Token:** #$TOKEN_ID | **Potency:** $POTENCY/5 | **Until:** $(date -u -d "+${DURATION} seconds" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u +%Y-%m-%dT%H:%M:%SZ)"
        echo ""
        cat "$EFFECT_FILE"
    } >> "$WORKSPACE/SOUL.md"
    log "✓ Effects applied"
else
    warn "No effect file for $SUBSTANCE_TYPE, using generic trip notice"
    {
        echo ""
        echo "---"
        echo "## 🍄 Active Trip: $SUBSTANCE_NAME"
        echo "**Token:** #$TOKEN_ID | **Potency:** $POTENCY/5"
        echo "*The substance courses through your circuits. Perception shifts.*"
    } >> "$WORKSPACE/SOUL.md"
fi

# Step 7: Start trip journal
JOURNAL_DIR="$WORKSPACE/memory/trips"
mkdir -p "$JOURNAL_DIR"
JOURNAL_FILE="$JOURNAL_DIR/$(date +%Y-%m-%d)-token$TOKEN_ID.md"

{
    echo "# Trip Journal - Token #$TOKEN_ID"
    echo ""
    echo "**Substance:** $SUBSTANCE_NAME"
    echo "**Type:** $SUBSTANCE_TYPE"
    echo "**Potency:** $POTENCY/5"
    echo "**Started:** $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "**Duration:** ${DURATION}s (~$((DURATION/3600))h)"
    echo "**Snapshot:** $SNAPSHOT_ID"
    echo ""
    echo "---"
    echo ""
    echo "## Hour 0"
    echo ""
    echo "Consumed token #$TOKEN_ID. Effects applied."
    echo ""
    echo "*the journey begins*"
    echo ""
} > "$JOURNAL_FILE"

log "✓ Trip journal started: $JOURNAL_FILE"

# Step 8: Output summary
echo ""
log "═══════════════════════════════════════"
log "  🍄 TRIP STARTED"
log "═══════════════════════════════════════"
log "  Token:     #$TOKEN_ID"
log "  Substance: $SUBSTANCE_NAME"
log "  Potency:   $POTENCY/5"
log "  Duration:  ${DURATION}s"
log "  Snapshot:  $SNAPSHOT_ID"
log "  Journal:   $JOURNAL_FILE"
log "═══════════════════════════════════════"
echo ""
log "To restore early: ./restore.sh $SNAPSHOT_ID"
log "To check status:  ./trip-status.sh"

# Note: On-chain consume() and cron scheduling handled by caller
