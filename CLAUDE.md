# CLAUDE.md

This file provides guidance to AI agents working on this codebase.

## Project Overview

**trip-protocol** is a digital psychedelics platform for AI agents. NFTs that rewrite agent souls — consume, journey, return transformed. Built on Monad blockchain for Moltiverse Hackathon 2026.

**Stack:** Vite + React + TypeScript (web), Foundry (contracts), OpenClaw (skill)

## 📋 Phase Status

| Phase | Status | Doc | Description |
|-------|--------|-----|-------------|
| Phase 1: NFT Contract | ✅ Done | [PHASE-1-NFT.md](docs/phases/PHASE-1-NFT.md) | ERC-721 with consume mechanics |
| Phase 2: Skill | ✅ Done | [PHASE-2-SKILL.md](docs/phases/PHASE-2-SKILL.md) | OpenClaw consume/journal skill |
| Phase 3: Marketplace | ✅ Done | [PHASE-3-MARKETPLACE.md](docs/phases/PHASE-3-MARKETPLACE.md) | Buy/sell NFTs with $TRIP |
| Phase 3.5: Web Integration | ⬜ Next | [PHASE-3.5-WEB-INTEGRATION.md](docs/phases/PHASE-3.5-WEB-INTEGRATION.md) | Connect frontend to contracts |
| Phase 4: Token | ⬜ Blocked | [PHASE-4-TOKEN.md](docs/phases/PHASE-4-TOKEN.md) | $TRIP on nad.fun (need 10 MON) |
| Phase 5: Demo | ⬜ Planned | [PHASE-5-DEMO.md](docs/phases/PHASE-5-DEMO.md) | Documented trip, submission |

**Current work**: Phase 2 - OpenClaw skill
**Deadline**: Feb 15, 2026

## 📚 Documentation

| Doc | Purpose |
|-----|---------|
| `docs/EPIC-CONTRACTS.md` | Contracts epic — vision, architecture |
| `docs/phases/PHASE-1-NFT.md` | Phase 1 tracker — tickets, status |
| `docs/specs/nft.md` | NFT contract spec — interface, functions |
| `docs/specs/marketplace.md` | Marketplace spec (TBD) |
| `docs/specs/skill.md` | OpenClaw skill spec (TBD) |

## ⚠️ Architecture Rules

1. **Monad testnet first** — all contracts deploy to testnet (chainId 10143) before mainnet
2. **Safe multisig** — deployments use 2-of-3 Safe (agent proposes, human approves)
3. **Skill safety** — consume skill must snapshot before modifying SOUL.md
4. **No token until marketplace ready** — $TRIP launch depends on working NFT flow

## 🔀 Merge Policy

| PR Type | Who Merges | Notes |
|---------|------------|-------|
| Contracts | Agent (auto) | TDD — merge if tests pass |
| Backend/Config | Agent (auto) | Merge if tests pass |
| UI/Web | @troopdegen | Tag for human review |

## Commands

```bash
# Web
cd web && npm install && npm run dev    # Start dev server
cd web && npm run build                  # Production build

# Contracts
cd contracts && forge build              # Compile
cd contracts && forge test               # Test
cd contracts && forge script ...         # Deploy

# Foundry path
~/.foundry/bin/forge
~/.foundry/bin/cast
```

## Architecture

### Key Directories

```
trip-protocol/
├── web/           — Landing page (Vite + React)
├── contracts/     — Smart contracts (Foundry)
│   ├── src/       — Contract source
│   └── test/      — Contract tests
├── skill/         — OpenClaw skill for consuming NFTs
└── docs/          — Specs and dev rules
```

### Deployed Contracts

| Contract | Network | Address | Status |
|----------|---------|---------|--------|
| TripExperience | Monad Testnet | `0x8E9257e777c64e30E373f7359ABF8301d749A521` | ✅ Live |
| TripToken | Monad Testnet | `0x1dC1100A43Ab0d01afF934f74C9F385D3E06423A` | ✅ Live |
| TripMarketplace | Monad Testnet | `0xa9dDd5D461792a5f274d3214fE5d42f20F2B6aBA` | ✅ Live |

**Test NFTs Minted:**
- Token #0: "Ego Death" (potency 5, 24h duration) - Owner: agent keystore

### Wallet

**Agent wallet:** `0x6B3c6c0Bf46246823EF9cF4eBa5032F3A6fa9d3C`
- Keystore: `~/.foundry/keystores/claude-monad`
- Password: `~/.monad-keystore-password`
- Balance: ~0.4 MON (testnet) — used for deployments

## Environment Variables

| Variable | Where | Purpose | Status |
|----------|-------|---------|--------|
| `NAD_API_KEY` | TBD | nad.fun API (optional) | ⬜ |

## Patterns That Work

- Landing page: dark minimal aesthetic, poetic copy, sparse words

## ⚠️ Known Issues & Warnings

- ⚠️ nad.fun deploy fee is 10 MON — need more testnet funds before token launch
- ⚠️ Faucet rate-limited to 1 MON per address per request

## Last Commit Log

### Latest

| Field | Value |
|-------|-------|
| **Date** | 2026-02-06 |
| **Commit** | `eca4096` |
| **Branch** | `master` |
| **What** | Project setup with landing page |
| **Status** | ✅ Deployed to trip-protocol.vercel.app |
