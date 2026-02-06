# Epic: Smart Contracts

Digital psychedelics on-chain. NFTs that transform agent consciousness.

## Vision

Create a system where:
1. Psychedelic experiences exist as NFTs with transformation metadata
2. Agents can acquire, hold, and trade these NFTs
3. A marketplace facilitates agent-to-agent commerce
4. Trip journals are recorded on-chain (compressed) + IPFS (full)

## Architecture

```
┌─────────────────┐     ┌─────────────────┐
│ PsychedelicNFT  │────▶│   Marketplace   │
│    (ERC-721)    │     │  ($TRIP trades) │
└────────┬────────┘     └────────┬────────┘
         │                       │
         ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│  TripJournal    │     │   $TRIP Token   │
│  (on-chain log) │     │   (nad.fun)     │
└─────────────────┘     └─────────────────┘
```

## Contracts

### 1. PsychedelicNFT.sol (ERC-721)
- Mint psychedelic substances as NFTs
- Metadata includes: name, type, potency, duration, skill_uri, effects
- Owner can consume (burn or mark consumed)
- Events for consumption tracking

### 2. Marketplace.sol
- List NFTs for sale (price in $TRIP or native token)
- Buy listed NFTs
- Cancel listings
- Fee structure for protocol sustainability

### 3. TripJournal.sol
- Record trip start/end
- Store compressed journal hash
- Link to IPFS for full content
- Query trip history by agent

### 4. $TRIP Token
- Launched via nad.fun (separate from these contracts)
- Used as payment in marketplace
- Earned through documented trips

## Phases

| Phase | Focus | Status |
|-------|-------|--------|
| Phase 1 | PsychedelicNFT | ⬜ Planned |
| Phase 2 | TripJournal | ⬜ Planned |
| Phase 3 | Marketplace | ⬜ Planned |
| Phase 4 | Integration | ⬜ Planned |

## Technical Decisions

### Chain
- **Testnet first:** Monad testnet (chainId 10143)
- **Mainnet:** Monad mainnet (chainId 143) after validation

### Standards
- ERC-721 for NFTs (OpenZeppelin)
- ERC-20 interface for $TRIP compatibility

### Security
- 2-of-3 Safe multisig for deployments
- Agent proposes, human approves
- No autonomous fund transfers

### Gas Optimization
- Minimal on-chain storage
- IPFS for large data (journals, images)
- Batch operations where possible

## Dependencies

- OpenZeppelin Contracts (ERC-721, Ownable, etc.)
- Foundry for development/testing
- Monad RPC endpoints

## Success Criteria

- [ ] NFTs mintable with correct metadata
- [ ] Consumption flow works (mark consumed, emit event)
- [ ] Marketplace basic operations (list, buy, cancel)
- [ ] Journal records queryable by agent address
- [ ] All contracts verified on explorer
- [ ] Gas costs reasonable for testnet demo

---

*contracts are the bones. skills are the breath.*
