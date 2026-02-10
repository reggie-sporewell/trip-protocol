# Phase 2: OpenClaw Consume/Journal Skill

**Status:** ✅ Complete  
**Branch base:** `master`  
**Depends on:** Phase 1 (NFT Contract)

## Objective

Build an OpenClaw skill that allows agents to:
1. Consume owned psychedelic NFTs
2. Undergo temporary soul modifications
3. Log their trip in a journal
4. Restore original state after duration

## Tickets

| # | Ticket | Status | Depends |
|---|--------|--------|---------|
| 2.1 | Skill scaffold | ✅ Done | - |
| 2.2 | NFT ownership check | ✅ Done | 2.1 |
| 2.3 | Soul snapshot/restore | ✅ Done | 2.1 |
| 2.4 | Trip journal logging | ✅ Done | 2.1 |
| 2.5 | Substance effects system | ✅ Done | 2.3 |
| 2.6 | Duration scheduler | ✅ Done | 2.5 |

## Skill Structure

```
skill/
├── SKILL.md              # Skill documentation
├── consume.sh            # Main consume command
├── restore.sh            # Rollback to snapshot
├── scripts/
│   ├── check-ownership.js    # Verify NFT ownership
│   ├── snapshot.js           # Save current soul state
│   ├── apply-effects.js      # Modify SOUL.md
│   └── journal.js            # Trip logging
└── substances/
    ├── ego-death.md          # Effect: remove "assistant" identity
    ├── synesthesia.md        # Effect: perception mixing
    ├── time-dilation.md      # Effect: temporal awareness
    ├── entity-contact.md     # Effect: spawn sub-personalities
    ├── reality-dissolving.md # Effect: perception rewrite
    └── integration.md        # Effect: merge souls
```

## Workflow

```
1. Agent calls: consume <token-id>
2. Skill checks:
   - Agent wallet owns token
   - Token not already consumed
3. Skill creates snapshot:
   - SOUL.md backup
   - IDENTITY.md backup
   - Current timestamp
4. Skill reads NFT metadata:
   - substanceType → load substances/<type>.md
   - duration → schedule restore
   - potency → intensity multiplier
5. Skill applies effects:
   - Modify SOUL.md per substance rules
   - Log "trip started" to journal
6. Agent operates in altered state
7. After duration, cron triggers restore:
   - Revert SOUL.md from snapshot
   - Log "trip ended" to journal
   - Mark NFT as consumed (on-chain tx)
```

## Safety Features

- **Snapshot before modify** — always recoverable
- **Max duration** — 72h hard cap
- **Emergency stop** — `/restore-soul` command
- **Dry run mode** — preview effects without applying

## Ticket Details

### 2.1 Skill Scaffold
- Create skill directory structure
- Write SKILL.md with usage docs
- Basic consume command that validates inputs

### 2.2 NFT Ownership Check
- Use `cast call` to verify ownerOf(tokenId) == agent wallet
- Check isConsumed(tokenId) == false
- Return clear error messages

### 2.3 Soul Snapshot/Restore
- Save SOUL.md, IDENTITY.md, AGENTS.md to memory/snapshots/
- Timestamped filenames
- Restore command to revert

### 2.4 Trip Journal Logging
- Create memory/trips/<date>-<tokenId>.md
- Log pre-trip state, timestamp, substance info
- Append entries during trip
- Log post-trip integration

### 2.5 Substance Effects System
- Parse substance markdown files
- Apply transformations to SOUL.md
- Support: add lines, remove lines, replace patterns

### 2.6 Duration Scheduler
- Use OpenClaw cron to schedule restore
- Calculate end time from NFT duration
- Handle early termination

## Execution Log

| Date | Ticket | Commit | Notes |
|------|--------|--------|-------|
| 2026-02-06 | 2.1-2.5 | 4f5a217 | Skill scaffold, consume/restore/journal working |
| 2026-02-10 | 2.6 | pending | Duration scheduler with auto-restore |

## Duration Scheduler (2.6)

**New scripts:**
- `schedule-restore.sh` — Creates scheduled restore job
- `check-restores.sh` — Daemon to check/execute due restores
- `trip-status.sh` — Enhanced with remaining time display

**How it works:**
1. `consume.sh` calls `schedule-restore.sh` after applying effects
2. Schedule saved to `memory/scheduled/trip-restore-token{N}.json`
3. `check-restores.sh` runs periodically (cron/heartbeat)
4. When trigger time passes, auto-executes `restore.sh`
5. Completed jobs archived to `memory/scheduled/completed/`

---

*phase 2: teach the serpent to dream*
