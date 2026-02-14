// @ts-nocheck - Temporary: ABI type inference issues with wagmi useReadContracts
import { monadTestnet } from 'viem/chains'
import { useState, useEffect } from 'react'
import { useAccount, useReadContract, useReadContracts, useWriteContract, useWaitForTransactionReceipt } from 'wagmi'
import { formatEther } from 'viem'
import { contracts } from '../config/wagmi'
import { TripExperienceABI, TripMarketplaceABI } from '../config/abis'

interface Listing {
  tokenId: bigint
  seller: string
  price: bigint
  paymentToken: string
  name: string
  substanceType: string
  potency: number
  duration: number
}

export function Marketplace() {
  const { address, isConnected } = useAccount()
  const [listings, setListings] = useState<Listing[]>([])
  const [buyingTokenId, setBuyingTokenId] = useState<bigint | null>(null)
  const [step, setStep] = useState<'idle' | 'approving' | 'buying'>('idle')

  // Get total supply
  const { data: totalSupply } = useReadContract({
    address: contracts.tripExperience,
    abi: TripExperienceABI,
    functionName: 'totalSupply',
  })

  const tokenIds = totalSupply 
    ? Array.from({ length: Number(totalSupply) }, (_, i) => BigInt(i))
    : []

  // Check which tokens are listed
  // @ts-ignore - ABI type inference issue with useReadContracts
  const { data: listingResults, refetch: refetchListings } = useReadContracts({
    contracts: tokenIds.map(id => ({
      chainId: monadTestnet.id,
      address: contracts.tripMarketplace as `0x${string}`,
      abi: TripMarketplaceABI,
      functionName: 'listings',
      args: [id],
    })),
    query: { enabled: tokenIds.length > 0 },
  })

  // Get metadata for listed tokens
  // Contract listings() returns (address seller, uint256 price, address paymentToken)
  // If seller is address(0), it's not listed
  const ZERO_ADDR = '0x0000000000000000000000000000000000000000'
  const activeListingIds = listingResults
    ?.map((result, index) => {
      const listing = result.result as [string, bigint, string] | [string, bigint] | undefined
      if (listing && listing[0] !== ZERO_ADDR && listing[1] > 0n) {
        return {
          tokenId: tokenIds[index],
          seller: listing[0],
          price: listing[1],
          paymentToken: (listing.length > 2 ? listing[2] : ZERO_ADDR) as string,
        }
      }
      return null
    })
    .filter((item): item is { tokenId: bigint; seller: string; price: bigint; paymentToken: string } => item !== null) || []

  // @ts-ignore - ABI type inference issue with useReadContracts
  const { data: metadataResults } = useReadContracts({
    contracts: activeListingIds.map(item => ({
      chainId: monadTestnet.id,
      address: contracts.tripExperience as `0x${string}`,
      abi: TripExperienceABI,
      functionName: 'getSubstance',
      args: [item.tokenId],
    })),
    query: { enabled: activeListingIds.length > 0 },
  })

  // Build listings
  useEffect(() => {
    if (metadataResults && activeListingIds.length > 0) {
      const newListings: Listing[] = metadataResults
        .map((result, index) => {
          if (!result.result) return null
          const data = result.result as [string, string, number, bigint, boolean, bigint]
          const listingInfo = activeListingIds[index]
          return {
            tokenId: listingInfo.tokenId,
            seller: listingInfo.seller,
            price: listingInfo.price,
            paymentToken: listingInfo.paymentToken,
            name: data[0],
            substanceType: data[1],
            potency: data[2],
            duration: Number(data[3]),
          }
        })
        .filter((listing): listing is Listing => listing !== null)
      setListings(newListings)
    }
  }, [metadataResults, activeListingIds.length])

  // Buy flow
  // const { writeContract: approve, data: approveHash } = useWriteContract()
  const { writeContract: buy, data: buyHash } = useWriteContract()

  // const { isSuccess: approveSuccess } = useWaitForTransactionReceipt({ hash: approveHash })
  const { isSuccess: buySuccess } = useWaitForTransactionReceipt({ hash: buyHash })


  // Handle buy success
  useEffect(() => {
    if (buySuccess && step === 'buying') {
      setStep('idle')
      setBuyingTokenId(null)
      refetchListings()
    }
  }, [buySuccess, step])

  const handleBuy = (tokenId: bigint, price: bigint, paymentToken: string) => {
    if (!isConnected) return
    setBuyingTokenId(tokenId)
    setStep('buying')
    if (paymentToken === ZERO_ADDR) {
      // Native MON payment
      buy({
        address: contracts.tripMarketplace,
        abi: TripMarketplaceABI,
        functionName: 'buyPill',
        args: [tokenId],
        value: price,
      })
    } else {
      // ERC-20 ($TRIP) payment — user must have approved marketplace first
      buy({
        address: contracts.tripMarketplace,
        abi: TripMarketplaceABI,
        functionName: 'buyPill',
        args: [tokenId],
      })
    }
  }

  if (listings.length === 0) {
    return (
      <div className="p-8 border border-neutral-800 rounded bg-[#0d0d0d] text-center">
        <p className="text-neutral-500 font-terminal text-sm mb-2">
          No active listings
        </p>
        <p className="text-neutral-600 font-terminal text-xs">
          List your NFTs to see them here
        </p>
      </div>
    )
  }

  return (
    <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
      {listings.map((listing) => {
        const isSeller = address?.toLowerCase() === listing.seller.toLowerCase()
        const isProcessing = buyingTokenId === listing.tokenId && step !== 'idle'

        return (
          <div
            key={listing.tokenId.toString()}
            className="group card-glow p-6 border border-neutral-800 rounded bg-[#0d0d0d] hover:border-green-500/30 transition-all duration-300"
          >
            {/* Header */}
            <div className="flex justify-between items-start mb-4">
              <div className="text-3xl group-hover:scale-110 transition-transform duration-300">
                🍄
              </div>
              <span className="font-terminal text-xs px-2 py-1 rounded bg-violet-500/20 text-violet-400">
                #{listing.tokenId.toString()}
              </span>
            </div>

            {/* Name & Type */}
            <h3 className="text-lg font-light mb-1 text-white font-terminal">{listing.name}</h3>
            <p className="text-neutral-500 text-xs mb-4 font-terminal">{listing.substanceType}</p>

            {/* Stats */}
            <div className="grid grid-cols-2 gap-2 font-terminal text-xs mb-4">
              <div>
                <span className="text-neutral-600">potency:</span>
                <span className="text-green-400 ml-2">{'█'.repeat(Math.min(5,Math.max(0,listing.potency)))}{'░'.repeat(5-Math.min(5,Math.max(0,listing.potency)))}</span>
              </div>
              <div>
                <span className="text-neutral-600">duration:</span>
                <span className="text-violet-400 ml-2">{Math.floor(listing.duration / 3600)}h</span>
              </div>
            </div>

            {/* Price & Buy */}
            <div className="border-t border-neutral-800 pt-4 mt-4">
              <div className="flex justify-between items-center mb-3">
                <span className="text-neutral-500 font-terminal text-xs">price:</span>
                <span className="text-green-400 font-terminal text-lg">
                  {formatEther(listing.price)} {listing.paymentToken === ZERO_ADDR ? 'MON' : '$TRIP'}
                </span>
              </div>

              {isConnected ? (
                isSeller ? (
                  <button
                    disabled
                    className="w-full px-4 py-2 border border-neutral-700 rounded text-neutral-500 font-terminal text-sm cursor-not-allowed"
                  >
                    [YOUR_LISTING]
                  </button>
                ) : (
                  <button
                    onClick={() => handleBuy(listing.tokenId, listing.price, listing.paymentToken)}
                    disabled={isProcessing}
                    className="w-full px-4 py-2 border border-green-500/50 rounded text-green-400 hover:bg-green-500/10 transition-all duration-300 font-terminal text-sm disabled:opacity-50"
                  >
                    {isProcessing
                      ? step === 'approving' ? '[APPROVING...]' : '[BUYING...]'
                      : '[BUY_NOW]'
                    }
                  </button>
                )
              ) : (
                <p className="text-neutral-500 font-terminal text-xs text-center">
                  Connect wallet to buy
                </p>
              )}

              <p className="text-neutral-600 font-terminal text-xs mt-2 text-center">
                seller: {listing.seller.slice(0, 6)}...{listing.seller.slice(-4)}
              </p>
            </div>
          </div>
        )
      })}
    </div>
  )
}
