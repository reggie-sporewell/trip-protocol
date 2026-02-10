# Phase 3.5: Web Integration

**Status:** ✅ Complete  
**Branch base:** `master`  
**Depends on:** Phase 1 (NFT), Phase 3 (Marketplace), Phase 4 (Token)

## Objective

Connect the landing page to smart contracts so users can:
1. Connect wallet
2. Claim $TRIP from faucet
3. Browse and buy NFTs from marketplace
4. View owned NFTs and consumption status

## Tickets

| # | Ticket | Status | Depends |
|---|--------|--------|---------|
| 3.5.1 | Wallet connection (wagmi/viem) | ✅ | - |
| 3.5.2 | Contract hooks | ✅ | 3.5.1 |
| 3.5.3 | $TRIP faucet button | ✅ | 3.5.2 |
| 3.5.4 | NFT gallery (owned) | ✅ | 3.5.2 |
| 3.5.5 | Marketplace browse/buy | ✅ | 3.5.2 |
| 3.5.6 | List NFT for sale | ✅ | 3.5.5 |

## Tech Stack

- **wagmi** — React hooks for Ethereum
- **viem** — TypeScript Ethereum client
- **monadTestnet** — Chain config from viem/chains
- **RainbowKit** (optional) — Wallet modal UI

## Contract Addresses (Monad Testnet)

```typescript
const contracts = {
  tripExperience: "0x8E9257e777c64e30E373f7359ABF8301d749A521",
  tripToken: "0x1dC1100A43Ab0d01afF934f74C9F385D3E06423A",
  tripMarketplace: "0xa9dDd5D461792a5f274d3214fE5d42f20F2B6aBA",
} as const;
```

## Ticket Details

### 3.5.1 Wallet Connection

```typescript
// wagmi config
import { createConfig, http } from 'wagmi'
import { monadTestnet } from 'viem/chains'

const config = createConfig({
  chains: [monadTestnet],
  transports: {
    [monadTestnet.id]: http()
  }
})
```

Components:
- Connect button in header
- Display connected address
- Disconnect option

### 3.5.2 Contract Hooks

Create custom hooks for each contract:

```typescript
// useTripToken.ts
export function useTripBalance(address: Address) { ... }
export function useTripFaucet() { ... }
export function useTripApprove() { ... }

// useTripExperience.ts
export function useOwnedNFTs(address: Address) { ... }
export function useNFTMetadata(tokenId: bigint) { ... }
export function useIsConsumed(tokenId: bigint) { ... }

// useTripMarketplace.ts
export function useListings() { ... }
export function useBuyNFT() { ... }
export function useListNFT() { ... }
```

### 3.5.3 $TRIP Faucet Button

- Button in marketplace section
- Calls `tripToken.faucet()`
- Shows success toast with amount received
- Displays current balance

### 3.5.4 NFT Gallery

- Grid of owned TripExperience NFTs
- Show: name, potency, duration, consumed status
- Click to view details
- "List for Sale" button on each

### 3.5.5 Marketplace Browse/Buy

- Grid of active listings
- Show: NFT details, price in $TRIP, seller
- "Buy" button
- Approve $TRIP → Buy flow
- Success/error toasts

### 3.5.6 List NFT for Sale

- Select NFT from owned gallery
- Input price in $TRIP
- Approve NFT → List flow
- Show in marketplace after listing

## UI/UX Notes

- Keep dark aesthetic from landing page
- Terminal/hacker font for prices and addresses
- Glitch effects on hover
- Toast notifications for tx status
- Skeleton loaders during fetches

## Flow Diagrams

### Buy Flow
```
Connect Wallet
    ↓
Browse Marketplace
    ↓
Click "Buy" on listing
    ↓
Approve $TRIP (if needed)
    ↓
Confirm Buy tx
    ↓
NFT transferred, $TRIP deducted
```

### List Flow
```
Connect Wallet
    ↓
View My NFTs
    ↓
Click "List for Sale"
    ↓
Enter price
    ↓
Approve NFT transfer (if needed)
    ↓
Confirm List tx
    ↓
Appears in marketplace
```

## Execution Log

| Date | Ticket | Commit | Notes |
|------|--------|--------|-------|
| - | - | - | - |

---

*phase 3.5: the interface awakens*
