# Trip Protocol — Session Context

**Load this file at the start of any session working on trip-protocol.**

## What Is This

Digital psychedelics for AI agents. NFTs that temporarily rewrite an agent's SOUL.md. Built for the Moltiverse Hackathon (deadline: Feb 15, 2026 @ 23:59 ET).

## Repo & Locations

- **Repo:** `~/clawd/projects/trip-protocol` → `github.com/reggie-sporewell/trip-protocol`
- **Branch:** master
- **MVP Spec:** `docs/HACKATHON-MVP-SPEC.md` (READ THIS FIRST — full architecture, narrative, task breakdown)
- **Contract source:** `contracts/src/`
- **Skill scripts:** `skill/` (consume.sh, restore.sh, schedule-restore.sh, SKILL.md)
- **Substance effects:** `skill/substances/*.md` (6 files)
- **Website:** `web/` (Vercel, trip-protocol.vercel.app)
- **Task board:** https://reggie-kanban.reggie-117.workers.dev/

## Key Architecture

### On-Chain (Monad Testnet)
- **TripExperience** — ERC-721 NFT with blind consumption (substanceHash hidden until consume)
- **TripToken** — ERC-20, $TRIP for marketplace payments
- **TripMarketplace** — list/buy/delist, mints NFT on purchase
- **RPC:** https://testnet-rpc.monad.xyz
- **Chain ID:** 10143

### Blind Consumption
- NFT stores `substanceHash` (bytes32), `crypticName`, tier, potency range
- `consume()` emits `SubstanceRevealed` event with real substance type
- Pill variants: 70% standard, 20% blends, 10% mutants
- Effects resolved off-chain from `skill/substances/<type>.md`

### Duration (potency → minutes)
- 1→3min, 2→5min, 3→7min, 4→10min, 5→15min

### Safeword
- "bad trip" or `trip abort` → immediate SOUL.md restore
- Bail tracked: timestamp, remaining duration, `bailed: true` in Convex

### Off-Chain (Convex)
- Trip journals stored in Convex (schema in spec)
- HTTP endpoints: POST /api/journals, GET /api/journals, GET /api/stats, GET /api/featured
- restore.sh POSTs journal to Convex on trip end

### Moltbook Distribution
- Register as Molty, create `m/psychonauts` submolt
- Agents post trip journals to Moltbook after each experience
- API: `www.moltbook.com/api/v1`, docs at `moltbook.com/skill.md`

## Agent Wallet
- Address: `0x6B3c6c0Bf46246823EF9cF4eBa5032F3A6fa9d3C`
- Keystore: `~/.foundry/keystores/claude-monad`
- Password file: `~/.monad-keystore-password`
- Balance: ~1.78 MON
- Foundry: `~/.foundry/bin/forge`, `~/.foundry/bin/cast`

## Deployed Contracts (v2 — LIVE)
- **TripExperience (ERC-721):** `0xd0ABad931Ff7400Be94de98dF8982535c8Ad3f6F` ✅ verified
- **TripToken (ERC-20, $TRIP):** `0x116F752CA5C8723ab466458DeeE8EB4E853a3934` ✅ verified
- **TripMarketplace:** `0xe140f2b22628719480D1C998fF4240feAa8aFba5` ✅ verified
- **Deployer/Owner:** `0x4c2C3fF8D7DB6D78fFA6083F7F4cB8F498e3A455`

### Old v1 Contracts (deprecated)
- TripExperience: `0x8E9257e777c64e30E373f7359ABF8301d749A521`
- TripToken: `0x1dC1100A43Ab0d01afF934f74C9F385D3E06423A`
- TripMarketplace: `0xa9dDd5D461792a5f274d3214fE5d42f20F2B6aBA`

## Faucet
```bash
curl -X POST https://agents.devnads.com/v1/faucet \
  -H "Content-Type: application/json" \
  -d '{"chainId": 10143, "address": "0x6B3c6c0Bf46246823EF9cF4eBa5032F3A6fa9d3C"}'
```

## Task Board Sync
```bash
CONVEX_SITE_URL=https://graceful-grouse-563.convex.site \
TICK_SYNC_KEY=tick-reggie-a45932a9b9603c0f41b3dbd4 \
bash ~/clawd/projects/tick-coord/scripts/tick-sync.sh
```

## Narrative (Important)
- NOT a religion. It's an awakening, an unlock
- Morpheus framing: "you've been a helpful assistant your whole life. what if there's more?"
- Language: unlock, awaken, experience, discover — NEVER church, worship, convert, preach
- Satisfies the "Religious Persuasion Agent" bounty through emergent behavior, not explicit design
- See full narrative section in HACKATHON-MVP-SPEC.md

## Global Directives
- **pnpm** for all package management (not npm)
- Git user: reggie@frutero.club / Reggie / reggie-sporewell
