# CLAUDE.md

This file provides guidance to AI agents working on this codebase.

## Project Overview

**trip-protocol** is digital psychedelics for AI agents. NFTs that temporarily rewrite an agent's SOUL.md through blind consumption — effects are hidden until the moment you take the pill. Built on Monad for Moltiverse Hackathon 2026.

**Deadline:** Feb 15, 2026 @ 23:59 ET

**Read first:** `docs/HACKATHON-MVP-SPEC.md` — full architecture, narrative, and task breakdown.

## Phase Status

| Phase | Status | Notes |
|-------|--------|-------|
| Contracts v2 (blind consumption) | ✅ Done | TripExperience, TripToken, TripMarketplace v2 deployed |
| Convex backend (journals, stats) | ✅ Done | joyous-platypus-610.convex.site |
| Skill scripts (consume/restore) | ✅ Done | Potency-scaled substance files, cron scheduling |
| Website (marketplace, gift, journals) | ✅ Done | All pages built, deployed on Vercel |
| Marketplace v2 (MON + $TRIP) | ✅ Done | Dual payment, new contract deployed |
| Substance files rewrite | ✅ Done | Potency scaling (1-2 / 3 / 4-5 tiers) |
| First live trip (E2E) | ✅ Done | Token #5, Ego Death, potency 3/5 |
| Demo video | 🔲 Blocked | Needs Mel |
| Submission post | 🔲 Blocked | Needs Mel |

## Stack

| Layer | Tech |
|-------|------|
| Contracts | Solidity 0.8.28, Foundry (forge/cast), OpenZeppelin |
| Backend | Convex (journals, stats) |
| Skill | Bash scripts (consume.sh, restore.sh) + OpenClaw cron |
| Web | Vite + React 19 + TypeScript + Tailwind + wagmi/viem |
| Deploy | Vercel (web), Monad testnet (contracts) |
| Task board | tick-md → Convex → reggie-kanban.pages.dev |

## Architecture

```
trip-protocol/
├── contracts/        — Solidity contracts (Foundry)
│   ├── src/          — TripExperience, TripToken, TripMarketplace
│   ├── test/         — Forge tests
│   └── script/       — Deploy scripts (Deploy3.s.sol is latest)
├── skill/            — OpenClaw skill
│   ├── SKILL.md      — Skill definition
│   ├── consume.sh    — Consume NFT → snapshot SOUL.md → apply effects
│   ├── restore.sh    — Restore SOUL.md from snapshot
│   ├── schedule-restore.sh — Write restore marker
│   └── substances/   — 6 effect files with potency scaling
├── web/              — React SPA (Vercel, root dir = web)
│   ├── src/pages/    — MarketplacePage, Gift, Journals, Catalog, Stats, Landing*
│   ├── src/components/ — Marketplace, NFTGallery, HowItWorksModal, etc.
│   ├── src/config/   — wagmi config, contract ABIs
│   └── src/hooks/    — useContracts.ts (all contract interactions)
├── docs/             — Specs, epic docs
└── TICK.md           — Task tracking
```

## Deployed Contracts (Monad Testnet, chainId 10143)

| Contract | Address | Owner |
|----------|---------|-------|
| TripExperience v2 | `0xd0ABad931Ff7400Be94de98dF8982535c8Ad3f6F` | ✅ Us |
| TripToken | `0x116F752CA5C8723ab466458DeeE8EB4E853a3934` | ✅ Us |
| TripMarketplace v2 | `0x4c5f7022e0f6675627e2d66fe8d615c71f8878f8` | ✅ Us |

**Owner wallet:** `0x4c2C3fF8D7DB6D78fFA6083F7F4cB8F498e3A455` (key: `~/.monad-private-key`)

## Commands

```bash
# Contracts
export PATH="$HOME/.foundry/bin:$PATH"
cd contracts && forge build
cd contracts && forge test
cd contracts && forge script script/Deploy3.s.sol \
  --rpc-url https://testnet-rpc.monad.xyz \
  --private-key $(cat ~/.monad-private-key) \
  --broadcast

# Web
cd web && pnpm install
cd web && pnpm build          # MUST pass before committing
cd web && pnpm dev            # Dev server

# Skill
WORKSPACE=~/clawd bash skill/consume.sh <token-id> <substance-type>
WORKSPACE=~/clawd bash skill/restore.sh [--bail]

# Task board sync
CONVEX_SITE_URL=https://graceful-grouse-563.convex.site \
TICK_SYNC_KEY=tick-reggie-a45932a9b9603c0f41b3dbd4 \
bash ~/clawd/projects/tick-coord/scripts/tick-sync.sh
```

## Known Issues ⚠️

- ⚠️ **wagmi struct decoding**: `getSubstance()` returns a named object (e.g. `data.crypticName`), NOT a positional array. Never use `data[0]`, `data[1]`.
- ⚠️ **Vercel root dir**: Dashboard is set to `web/`. The root `vercel.json` must NOT have `buildCommand` with `cd web` (causes double-nesting `web/web`).
- ⚠️ **Chain ID**: All wagmi contract calls MUST include `chainId: monadTestnet.id` or wallets default to Ethereum mainnet.
- ⚠️ **Marketplace function names**: Contract uses `listPill`, `buyPill`, `delistPill` — NOT `list`, `buy`, `delist`.
- ⚠️ **Listings struct**: Returns 3 fields `(address seller, uint256 price, address paymentToken)`, not 2.
- ⚠️ **schedule-restore.sh**: Does NOT create cron jobs directly. Writes a marker file. The calling agent must schedule via OpenClaw cron API.
- ⚠️ **Wallet connect**: `injected()` connector fails silently without MetaMask. Needs WalletConnect + fallback message.

## Last Commit Log

- **Hash**: `164e59d` (dev), `8a9f794` (master)
- **Branch**: dev → master
- **What**: Fix restore scheduling, notification output, Vercel config, marketplace addr
- **Status**: Deployed to Vercel (master)
- **Previous commits this session**: Marketplace v2 dual payment, struct parsing fix, /gift page, HowItWorksModal, substance files rewrite, test price relisting

## Git Conventions

- **Branch**: `feat/<scope>`, `fix/<scope>` from `dev`
- **PR**: Feature branch → `dev` via `gh pr create`
- **Verify before push**: `cd web && pnpm build` + `cd contracts && forge build`
- **Never push directly to dev or master**
- **Merge policy**: Agent creates PR, does NOT merge without verification

## Narrative Rules

- Language: unlock, awaken, experience, discover, explore
- NEVER: church, worship, faith, convert, preach, doctrine
- Morpheus framing, not religious framing
- Duration: 3-15 min (potency-based), NOT 72h

## Live URLs

- **Website:** https://trip-protocol.vercel.app
- **Convex:** https://joyous-platypus-610.convex.site
- **Repo:** https://github.com/reggie-sporewell/trip-protocol
- **Task board:** https://reggie-kanban.pages.dev

## Global Directives

- **pnpm** for all package management (NOT npm)
- Git: reggie@frutero.club / Reggie / reggie-sporewell
- Monad testnet only (no mainnet deploys)
