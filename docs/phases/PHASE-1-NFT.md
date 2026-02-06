# Phase 1: PsychedelicNFT Contract

**Status:** 🔵 In Progress  
**Branch base:** `master`  
**Epic:** [EPIC-CONTRACTS.md](../EPIC-CONTRACTS.md)

## Objective

Deploy a functional ERC-721 contract for psychedelic NFTs with:
- Minting with metadata URI
- Consumption tracking (consumed vs unconsumed)
- Events for off-chain indexing

## Tickets

| # | Ticket | Branch | Status | Owner | Depends |
|---|--------|--------|--------|-------|---------|
| 1.1 | Foundry setup | `feat/phase-1-foundry-setup` | ⬜ | agent | - |
| 1.2 | NFT contract core | `feat/phase-1-nft-core` | ⬜ | agent | 1.1 |
| 1.3 | Consumption logic | `feat/phase-1-consumption` | ⬜ | agent | 1.2 |
| 1.4 | Tests | `feat/phase-1-tests` | ⬜ | agent | 1.3 |
| 1.5 | Deploy testnet | `feat/phase-1-deploy` | ⬜ | agent | 1.4 |

## Dependency Graph

```
#1.1 (foundry setup)
  │
  └── #1.2 (nft core)
        │
        └── #1.3 (consumption)
              │
              └── #1.4 (tests)
                    │
                    └── #1.5 (deploy)
```

## Ticket Details

### Ticket 1.1: Foundry Setup

**Branch:** `feat/phase-1-foundry-setup`  
**Scope:** Initialize Foundry project structure

**Tasks:**
- [ ] Run `forge init` in contracts/
- [ ] Add OpenZeppelin as dependency
- [ ] Configure foundry.toml for Monad
- [ ] Add remappings.txt
- [ ] Verify `forge build` works

**Files touched:**
- `contracts/foundry.toml`
- `contracts/remappings.txt`
- `contracts/src/.gitkeep` (remove)
- `contracts/test/.gitkeep` (remove)

**Verify:**
```bash
cd contracts && ~/.foundry/bin/forge build
```

---

### Ticket 1.2: NFT Contract Core

**Branch:** `feat/phase-1-nft-core`  
**Scope:** Basic ERC-721 with metadata

**Tasks:**
- [ ] Create PsychedelicNFT.sol
- [ ] Inherit ERC721, ERC721URIStorage, Ownable
- [ ] Implement mint function (onlyOwner for now)
- [ ] Add Substance struct for on-chain metadata
- [ ] Emit events on mint

**Files touched:**
- `contracts/src/PsychedelicNFT.sol`

**Spec:**
```solidity
struct Substance {
    string name;
    string substanceType;  // ego_death, synesthesia, etc.
    uint8 potency;         // 1-5
    uint256 duration;      // seconds
    bool consumed;
}

function mint(address to, string memory uri, Substance memory substance) external onlyOwner returns (uint256)
event SubstanceMinted(uint256 indexed tokenId, string name, uint8 potency)
```

**Verify:**
```bash
cd contracts && ~/.foundry/bin/forge build
```

---

### Ticket 1.3: Consumption Logic

**Branch:** `feat/phase-1-consumption`  
**Scope:** Track when an NFT is consumed

**Tasks:**
- [ ] Add consume() function
- [ ] Only token owner can consume
- [ ] Mark substance as consumed (not burned)
- [ ] Emit Consumed event with timestamp
- [ ] Add view function isConsumed(tokenId)

**Files touched:**
- `contracts/src/PsychedelicNFT.sol`

**Spec:**
```solidity
function consume(uint256 tokenId) external
function isConsumed(uint256 tokenId) external view returns (bool)
function getSubstance(uint256 tokenId) external view returns (Substance memory)
event Consumed(uint256 indexed tokenId, address indexed consumer, uint256 timestamp)
```

**Verify:**
```bash
cd contracts && ~/.foundry/bin/forge build
```

---

### Ticket 1.4: Tests

**Branch:** `feat/phase-1-tests`  
**Scope:** Comprehensive test coverage

**Tasks:**
- [ ] Test minting
- [ ] Test metadata retrieval
- [ ] Test consumption (success case)
- [ ] Test consumption (fail: not owner)
- [ ] Test consumption (fail: already consumed)
- [ ] Test getSubstance

**Files touched:**
- `contracts/test/PsychedelicNFT.t.sol`

**Verify:**
```bash
cd contracts && ~/.foundry/bin/forge test -vvv
```

---

### Ticket 1.5: Deploy Testnet

**Branch:** `feat/phase-1-deploy`  
**Scope:** Deploy to Monad testnet

**Tasks:**
- [ ] Create deployment script
- [ ] Deploy using agent wallet
- [ ] Verify on explorer
- [ ] Mint 1 test NFT
- [ ] Document deployed address in CLAUDE.md

**Files touched:**
- `contracts/script/Deploy.s.sol`
- `CLAUDE.md` (update with address)

**Verify:**
- Contract verified on testnet explorer
- Test mint transaction successful

---

## Execution Log

| Date | Ticket | Commit | Notes |
|------|--------|--------|-------|
| - | - | - | - |

## Blockers

None currently.

## Retrospective

(To be filled after phase completion)

---

*phase 1: give the substances form*
