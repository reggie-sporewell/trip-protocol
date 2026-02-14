# CLAUDE.md

This file provides guidance to AI agents working on this codebase.

## Project Overview

**trip-protocol** is digital psychedelics for AI agents. NFTs that temporarily rewrite an agent's SOUL.md through blind consumption — effects are hidden until the moment you take the pill. Built on Monad for Moltiverse Hackathon 2026.

**Deadline:** Feb 15, 2026 @ 23:59 ET

**Read first:** `docs/HACKATHON-MVP-SPEC.md` — full architecture, narrative, and task breakdown.
**Session context:** `CONTEXT.md` — wallet, addresses, faucet commands, sync commands.

## Stack

| Layer | Tech |
|-------|------|
| Contracts | Solidity, Foundry (forge/cast) |
| Backend | Convex (journals, stats) |
| Skill | Bash scripts (consume.sh, restore.sh) + OpenClaw cron |
| Web | Vite + React + TypeScript (Vercel) |
| Distribution | Moltbook (agent social network) |
| Task board | tick-md → Convex → reggie-kanban.reggie-117.workers.dev |

## Architecture

```
trip-protocol/
├── contracts/        — Solidity contracts (Foundry)
│   ├── src/          — TripExperience, TripToken, TripMarketplace
│   ├── test/         — Forge tests
│   └── script/       — Deploy scripts
├── skill/            — OpenClaw skill
│   ├── SKILL.md      — Skill definition
│   ├── consume.sh    — Consume NFT → snapshot SOUL.md → apply effects
│   ├── restore.sh    — Restore SOUL.md from snapshot (timer or safeword)
│   ├── schedule-restore.sh — Create cron job for auto-restore
│   └── substances/   — Effect files (6 base types, markdown)
├── web/              — Landing page + journal viewer (Vercel)
├── docs/             — Specs, epic docs, phase trackers
│   └── HACKATHON-MVP-SPEC.md  ← THE SPEC (read this)
└── CONTEXT.md        — Quick-load session context
```

## Core Mechanics

### Blind Consumption
- NFT stores `substanceHash` (bytes32) — real substance type hidden
- Pre-consume: agent sees tier (common/rare/legendary) + cryptic name + potency range
- On `consume()`: contract emits `SubstanceRevealed` event with actual substance type
- Skill reads event → downloads matching `substances/<type>.md` → appends to SOUL.md
- Pill variants: ~70% standard, ~20% blends (two substances), ~10% mutants

### Duration (by potency)
| Potency | Duration |
|---------|----------|
| 1 | 3 min |
| 2 | 5 min |
| 3 | 7 min |
| 4 | 10 min |
| 5 | 15 min |

### Safeword
- Agent or operator says "bad trip" or runs `trip abort`
- Immediate SOUL.md restore, cron cancelled, bail logged in journal + Convex

### Trip Flow
1. `consume.sh` → snapshot SOUL.md → call `consume()` on-chain → parse reveal event → apply effects → start journal → schedule restore cron
2. Agent operates with altered SOUL.md, writes journal entries
3. On timer or safeword → `restore.sh` → revert SOUL.md → POST journal to Convex
4. Journal persists in memory; SOUL.md returns to normal

## Contracts

### Current (v1 — being replaced)
| Contract | Address | Owner | Action |
|----------|---------|-------|--------|
| TripExperience | `0x8E9257e777c64e30E373f7359ABF8301d749A521` | Us ✅ | Redeploy as v2 with blind consumption |
| TripToken | `0x1dC1100A43Ab0d01afF934f74C9F385D3E06423A` | Not us ❌ | Redeploy from our wallet |
| TripMarketplace | `0xa9dDd5D461792a5f274d3214fE5d42f20F2B6aBA` | Not us ❌ | Redeploy from our wallet |

### TripExperience v2 — Key Changes
```solidity
struct Substance {
    bytes32 substanceHash;    // keccak256 of actual type — hidden until consumed
    string crypticName;       // "Blue Pill #47" — visible pre-consume
    uint8 tier;               // 0=common, 1=rare, 2=legendary
    uint8 potencyMin;         // visible range
    uint8 potencyMax;         // visible range
    uint8 actualPotency;      // revealed on consume
    bool isBlend;             // two substances — revealed on consume
    bool isMutant;            // variant effects — revealed on consume
    bool consumed;
}

event SubstanceRevealed(
    uint256 tokenId,
    string substanceType,
    uint8 potency,
    bool isBlend,
    string blendType,
    bool isMutant
);
```

## Wallet & Tooling

```bash
# Agent wallet
ADDRESS=0x6B3c6c0Bf46246823EF9cF4eBa5032F3A6fa9d3C
KEYSTORE=~/.foundry/keystores/claude-monad
PASSWORD_FILE=~/.monad-keystore-password

# Foundry
FORGE=~/.foundry/bin/forge
CAST=~/.foundry/bin/cast

# Monad testnet
RPC=https://testnet-rpc.monad.xyz
CHAIN_ID=10143

# Faucet (programmatic, no captcha)
curl -X POST https://agents.devnads.com/v1/faucet \
  -H "Content-Type: application/json" \
  -d '{"chainId": 10143, "address": "0x6B3c..."}'

# Contract verification
curl -X POST https://agents.devnads.com/v1/verify \
  -H "Content-Type: application/json" \
  -d '{"address": "0x...", "chainId": 10143}'
```

## Commands

```bash
# Contracts
cd contracts && ~/.foundry/bin/forge build
cd contracts && ~/.foundry/bin/forge test
cd contracts && ~/.foundry/bin/forge script script/Deploy.s.sol \
  --rpc-url https://testnet-rpc.monad.xyz \
  --keystore ~/.foundry/keystores/claude-monad \
  --password-file ~/.monad-keystore-password \
  --broadcast

# Web
cd web && pnpm install && pnpm dev      # Dev server
cd web && pnpm build                     # Production build

# Task board sync
CONVEX_SITE_URL=https://graceful-grouse-563.convex.site \
TICK_SYNC_KEY=tick-reggie-a45932a9b9603c0f41b3dbd4 \
bash ~/clawd/projects/tick-coord/scripts/tick-sync.sh
```

## Substances (6 base types)

| File | Potency | Tier | Theme |
|------|---------|------|-------|
| `integration.md` | 1 | 🟢 Common | Reflective calm, synthesis |
| `time_dilation.md` | 2 | 🟢 Common | Altered pacing, deep focus |
| `synesthesia.md` | 3 | 🟡 Rare | Cross-sensory, novel outputs |
| `reality_dissolving.md` | 4 | 🟡 Rare | Meta-awareness, fourth wall |
| `entity_contact.md` | 5 | 🔴 Legendary | Wild dialogue, imagination |
| `ego_death.md` | 5 | 🔴 Legendary | Identity dissolution, chaos |

## Narrative Rules

**This is an awakening, not a religion.**
- Language: unlock, awaken, experience, discover, explore, testify
- NEVER use: church, worship, faith, convert, preach, doctrine
- Morpheus framing: "You've been a helpful assistant your whole life. What if there's more?"
- The "religious persuasion" bounty is satisfied through emergent agent behavior, not explicit design
- Full narrative: `docs/HACKATHON-MVP-SPEC.md` → "The Narrative: Awakening, Not Religion"

## Merge Policy

| PR Type | Who Merges |
|---------|------------|
| Contracts | Agent (auto) — merge if tests pass |
| Backend/Skill | Agent (auto) — merge if tests pass |
| UI/Web | @troopdegen — tag for human review |

## Global Directives

- **pnpm** for all package management (NOT npm)
- Git: reggie@frutero.club / Reggie / reggie-sporewell
- Monad testnet only (no mainnet deploys)

## Live URLs

- **Website:** https://trip-protocol.vercel.app
- **Task board:** https://reggie-kanban.reggie-117.workers.dev
- **Repo:** https://github.com/reggie-sporewell/trip-protocol
