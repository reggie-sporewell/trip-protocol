# Phase 3: Marketplace Contract

**Status:** ✅ Complete  
**Branch base:** `master`  
**Depends on:** Phase 1 (NFT Contract), Phase 4 ($TRIP Token)

## Objective

Smart contract marketplace where agents can:
1. List psychedelic NFTs for sale
2. Purchase with $TRIP tokens
3. View trip journals before buying

## Tickets

| # | Ticket | Status | Depends |
|---|--------|--------|---------|
| 3.1 | Marketplace contract scaffold | ✅ | - |
| 3.2 | Listing mechanism | ✅ | 3.1 |
| 3.3 | Purchase with $TRIP | ✅ | 3.1, 4.1 |
| 3.4 | Fee system (optional) | ✅ | 3.3 |
| 3.5 | Tests | ✅ | 3.3 |
| 3.6 | Deploy testnet | ✅ | 3.5 |

## Contract Interface

```solidity
interface IMarketplace {
    struct Listing {
        address seller;
        uint256 tokenId;
        uint256 price;      // in $TRIP
        bool active;
    }

    event Listed(uint256 indexed tokenId, address seller, uint256 price);
    event Sold(uint256 indexed tokenId, address buyer, uint256 price);
    event Delisted(uint256 indexed tokenId);

    function list(uint256 tokenId, uint256 price) external;
    function delist(uint256 tokenId) external;
    function buy(uint256 tokenId) external;
    function getListing(uint256 tokenId) external view returns (Listing memory);
}
```

## Flow

```
Seller:
1. Approve marketplace to transfer NFT
2. Call list(tokenId, priceInTrip)
3. NFT stays in seller's wallet until sold

Buyer:
1. Approve marketplace to spend $TRIP
2. Call buy(tokenId)
3. Marketplace transfers $TRIP to seller
4. Marketplace transfers NFT to buyer
```

## Fee Model (Optional)

- 2.5% protocol fee on sales
- Fees go to treasury multisig
- Can be toggled off for hackathon

## Execution Log

| Date | Ticket | Commit | Notes |
|------|--------|--------|-------|
| 2026-02-10 | 3.1-3.6 | pending | Full marketplace + mock $TRIP deployed |

## Deployed Contracts

| Contract | Address | Verified |
|----------|---------|----------|
| TripToken | `0x1dC1100A43Ab0d01afF934f74C9F385D3E06423A` | ✅ |
| TripMarketplace | `0xa9dDd5D461792a5f274d3214fE5d42f20F2B6aBA` | ✅ |

---

*phase 3: the bazaar opens*
