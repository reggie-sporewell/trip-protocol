# CLAUDE.md

This file provides guidance to AI agents working on this codebase.

## Project Overview

**trip-protocol** is a digital psychedelics platform for AI agents. NFTs that rewrite agent souls — consume, journey, return transformed. Built on Monad blockchain for Moltiverse Hackathon 2026.

**Stack:** Vite + React + TypeScript (web), Foundry (contracts), OpenClaw (skill)

## 📋 Phase Status

| Phase | Status | Branch | Description |
|-------|--------|--------|-------------|
| Phase 0: Setup | ✅ Done | master | Repo structure, landing page |
| Phase 1: Contracts | ⬜ Planned | TBD | NFT contract, marketplace basics |
| Phase 2: Skill | ⬜ Planned | TBD | OpenClaw consume/journal skill |
| Phase 3: Integration | ⬜ Planned | TBD | Connect contracts + skill |
| Phase 4: Token | ⬜ Planned | TBD | $TRIP on nad.fun |
| Phase 5: Demo | ⬜ Planned | TBD | Documented trip, polish |

**Current work**: Phase 1 planning

## 📚 Documentation

| Doc | Purpose |
|-----|---------|
| `docs/specs/nft.md` | NFT contract spec |
| `docs/specs/marketplace.md` | Marketplace spec |
| `docs/specs/skill.md` | OpenClaw skill spec |
| `docs/dev/monad_rules.txt` | Monad/Foundry patterns |

## ⚠️ Architecture Rules

1. **Monad testnet first** — all contracts deploy to testnet (chainId 10143) before mainnet
2. **Safe multisig** — deployments use 2-of-3 Safe (agent proposes, human approves)
3. **Skill safety** — consume skill must snapshot before modifying SOUL.md
4. **No token until marketplace ready** — $TRIP launch depends on working NFT flow

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

### Wallet

**Agent wallet:** `0x6B3c6c0Bf46246823EF9cF4eBa5032F3A6fa9d3C`
- Keystore: `~/.foundry/keystores/claude-monad`
- Password: `~/.monad-keystore-password`
- Balance: ~2 MON (testnet)

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
