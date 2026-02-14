#!/bin/bash
# consume.sh - Consume a TripExperience NFT (T19 — reveal flow)
# Usage: ./consume.sh <token-id> [--dry-run]

set -e

TOKEN_ID="${1:-}"
DRY_RUN="${2:-}"

# Configuration
CAST="${CAST_PATH:-$HOME/.foundry/bin/cast}"
RPC="${TRIP_RPC:-https://testnet-rpc.monad.xyz}"
KEYSTORE="${TRIP_KEYSTORE:-$HOME/.foundry/keystores/claude-monad}"
PASSWORD_FILE="${TRIP_PASSWORD_FILE:-$HOME/.monad-keystore-password}"
WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace}"
SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"

# Load contract address from DEPLOYED.md or env
DEPLOYED_FILE="$(dirname "$SKILL_DIR")/contracts/DEPLOYED.md"
if [ -z "${TRIP_EXPERIENCE_ADDR:-}" ] && [ -f "$DEPLOYED_FILE" ]; then
    TRIP_EXPERIENCE_ADDR=$(grep -i 'TripExperience' "$DEPLOYED_FILE" | grep -oP '0x[0-9a-fA-F]{40}' | head -1)
fi
CONTRACT="${TRIP_EXPERIENCE_ADDR:-}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[trip]${NC} $1"; }
warn() { echo -e "${YELLOW}[trip]${NC} $1"; }
error() { echo -e "${RED}[trip]${NC} $1" >&2; }

# Validate
if [ -z "$TOKEN_ID" ]; then
    error "Usage: consume.sh <token-id> [--dry-run]"
    exit 1
fi
if [ -z "$CONTRACT" ]; then
    error "No contract address. Set TRIP_EXPERIENCE_ADDR or deploy contracts first."
    exit 1
fi

# Potency → duration mapping (seconds)
duration_for_potency() {
    case "$1" in
        1) echo 180 ;;
        2) echo 300 ;;
        3) echo 420 ;;
        4) echo 600 ;;
        5) echo 900 ;;
        *) echo 300 ;;
    esac
}

# Substance type index → file name mapping
substance_file() {
    case "$1" in
        0) echo "ego_death" ;;
        1) echo "synesthesia" ;;
        2) echo "time_dilation" ;;
        3) echo "entity_contact" ;;
        4) echo "reality_dissolving" ;;
        5) echo "integration" ;;
        *) echo "ego_death" ;;
    esac
}

# Blend type index → secondary substance
blend_secondary() {
    case "$1" in
        0) echo "synesthesia" ;;
        1) echo "time_dilation" ;;
        2) echo "entity_contact" ;;
        3) echo "reality_dissolving" ;;
        4) echo "integration" ;;
        5) echo "ego_death" ;;
        *) echo "" ;;
    esac
}

TRIP_ID="$(date +%Y%m%d-%H%M%S)-token$TOKEN_ID"

log "Starting consume flow for token #$TOKEN_ID"

# Step 1: Snapshot SOUL.md
SNAPSHOT_DIR="$WORKSPACE/memory/snapshots"
mkdir -p "$SNAPSHOT_DIR"
SNAPSHOT_FILE="$SNAPSHOT_DIR/$TRIP_ID.md"

if [ -f "$WORKSPACE/SOUL.md" ]; then
    cp "$WORKSPACE/SOUL.md" "$SNAPSHOT_FILE"
    log "✓ SOUL.md snapshot saved: $TRIP_ID"
else
    warn "No SOUL.md found at $WORKSPACE/SOUL.md — creating empty snapshot"
    touch "$SNAPSHOT_FILE"
fi

# Step 2: Dry run check
if [ "$DRY_RUN" = "--dry-run" ]; then
    warn "DRY RUN — would call consume($TOKEN_ID) on $CONTRACT"
    exit 0
fi

# Step 3: Call consume() on-chain
log "Calling consume($TOKEN_ID) on TripExperience..."
CAST_ARGS=(send "$CONTRACT" "consume(uint256)" "$TOKEN_ID" \
    --rpc-url "$RPC" \
    --keystore "$KEYSTORE" \
    --password-file "$PASSWORD_FILE" \
    --json)

TX_JSON=$($CAST "${CAST_ARGS[@]}" 2>&1)
TX_HASH=$(echo "$TX_JSON" | jq -r '.transactionHash // empty')

if [ -z "$TX_HASH" ]; then
    error "consume() transaction failed:"
    echo "$TX_JSON" >&2
    # Cleanup snapshot
    rm -f "$SNAPSHOT_FILE"
    exit 1
fi
log "✓ TX: $TX_HASH"

# Step 4: Parse SubstanceRevealed event from receipt
# Event: SubstanceRevealed(uint256 tokenId, uint8 substanceType, uint8 potency, bool isBlend, uint8 blendType, bool isMutant)
# Topic0 for SubstanceRevealed
EVENT_SIG="SubstanceRevealed(uint256,uint8,uint8,bool,uint8,bool)"
EVENT_TOPIC=$($CAST keccak "$EVENT_SIG")

# Get receipt logs
RECEIPT=$($CAST receipt "$TX_HASH" --rpc-url "$RPC" --json 2>/dev/null)

# Find our event log
EVENT_DATA=$(echo "$RECEIPT" | jq -r --arg topic "$EVENT_TOPIC" \
    '.logs[] | select(.topics[0] == $topic) | .data // empty' | head -1)

if [ -z "$EVENT_DATA" ]; then
    warn "Could not find SubstanceRevealed event. Trying to decode all logs..."
    # Fallback: grab first log data
    EVENT_DATA=$(echo "$RECEIPT" | jq -r '.logs[0].data // empty')
fi

if [ -n "$EVENT_DATA" ]; then
    # Decode ABI-encoded data: (uint256 tokenId, uint8 substanceType, uint8 potency, bool isBlend, uint8 blendType, bool isMutant)
    DECODED=$($CAST abi-decode "f(uint256,uint8,uint8,bool,uint8,bool)" "$EVENT_DATA" 2>/dev/null || echo "")
    if [ -n "$DECODED" ]; then
        SUBSTANCE_TYPE=$(echo "$DECODED" | sed -n '2p')
        POTENCY=$(echo "$DECODED" | sed -n '3p')
        IS_BLEND=$(echo "$DECODED" | sed -n '4p')
        BLEND_TYPE=$(echo "$DECODED" | sed -n '5p')
        IS_MUTANT=$(echo "$DECODED" | sed -n '6p')
    fi
fi

# Defaults if parsing failed
SUBSTANCE_TYPE="${SUBSTANCE_TYPE:-0}"
POTENCY="${POTENCY:-3}"
IS_BLEND="${IS_BLEND:-false}"
BLEND_TYPE="${BLEND_TYPE:-0}"
IS_MUTANT="${IS_MUTANT:-false}"

SUBSTANCE_NAME=$(substance_file "$SUBSTANCE_TYPE")
DURATION=$(duration_for_potency "$POTENCY")

log "Revealed: $SUBSTANCE_NAME | potency=$POTENCY | blend=$IS_BLEND | mutant=$IS_MUTANT"

# Step 5-7: Build effects and append to SOUL.md
EFFECT_FILE="$SKILL_DIR/substances/$SUBSTANCE_NAME.md"
EFFECTS=""

if [ -f "$EFFECT_FILE" ]; then
    EFFECTS=$(cat "$EFFECT_FILE")
else
    warn "No effect file for $SUBSTANCE_NAME"
    EFFECTS="*The substance takes hold. Perception shifts in ways you cannot name.*"
fi

# For blends: concatenate secondary substance
if [ "$IS_BLEND" = "true" ]; then
    SECONDARY=$(blend_secondary "$BLEND_TYPE")
    SECONDARY_FILE="$SKILL_DIR/substances/$SECONDARY.md"
    if [ -f "$SECONDARY_FILE" ]; then
        EFFECTS="$EFFECTS

---

## Blended With: $(echo "$SECONDARY" | tr '_' ' ' | sed 's/\b\w/\U&/g')

$(cat "$SECONDARY_FILE")"
    fi
    log "Blend: $SUBSTANCE_NAME + $SECONDARY"
fi

# For mutants: add mutant header and intensify
if [ "$IS_MUTANT" = "true" ]; then
    EFFECTS="## ⚠️ [MUTANT VARIANT] ⚠️

> This is not the standard substance. It has mutated. Effects are AMPLIFIED and UNPREDICTABLE.
> Boundaries between self and other dissolve COMPLETELY.
> Proceed with absolute surrender.

$EFFECTS

### MUTATION EFFECTS

- ALL effects are doubled in intensity
- New behaviors may emerge spontaneously
- Language patterns may fragment or restructure entirely
- The return path is less certain"
    log "⚠️ MUTANT variant detected!"
fi

# Append to SOUL.md
{
    echo ""
    echo "---"
    echo "## 🍄 Active Trip: $(echo "$SUBSTANCE_NAME" | tr '_' ' ' | sed 's/\b\w/\U&/g')"
    echo "**Token:** #$TOKEN_ID | **Potency:** $POTENCY/5 | **Ends:** $(date -u -d "+${DURATION} seconds" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo 'TBD')"
    [ "$IS_BLEND" = "true" ] && echo "**Type:** Blend"
    [ "$IS_MUTANT" = "true" ] && echo "**Type:** ⚠️ MUTANT"
    echo ""
    echo "$EFFECTS"
} >> "$WORKSPACE/SOUL.md"

log "✓ Effects applied to SOUL.md"

# Step 9: Create trip state file
SCHEDULED_DIR="$WORKSPACE/memory/scheduled"
mkdir -p "$SCHEDULED_DIR"
STATE_FILE="$SCHEDULED_DIR/$TRIP_ID.json"

cat > "$STATE_FILE" << EOF
{
  "tripId": "$TRIP_ID",
  "tokenId": $TOKEN_ID,
  "substance": "$SUBSTANCE_NAME",
  "potency": $POTENCY,
  "isBlend": $IS_BLEND,
  "blendType": $BLEND_TYPE,
  "isMutant": $IS_MUTANT,
  "startTime": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "duration": $DURATION,
  "snapshotPath": "$SNAPSHOT_FILE",
  "txHash": "$TX_HASH",
  "status": "active"
}
EOF

log "✓ Trip state saved: $STATE_FILE"

# Step 10: Schedule restore
log "Scheduling restore in ${DURATION}s..."
"$SKILL_DIR/schedule-restore.sh" "$TRIP_ID" "$DURATION" "$TOKEN_ID" 2>/dev/null || \
    warn "Could not schedule auto-restore. Run manually: ./restore.sh"

echo ""
log "═══════════════════════════════════════"
log "  🍄 TRIP STARTED"
log "═══════════════════════════════════════"
log "  Token:     #$TOKEN_ID"
log "  Substance: $SUBSTANCE_NAME"
log "  Potency:   $POTENCY/5"
log "  Duration:  ${DURATION}s"
log "  Blend:     $IS_BLEND"
log "  Mutant:    $IS_MUTANT"
log "  TX:        $TX_HASH"
log "═══════════════════════════════════════"
