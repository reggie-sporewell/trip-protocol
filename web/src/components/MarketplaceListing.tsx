import { useState } from 'react'
import { useAccount, useWriteContract, useWaitForTransactionReceipt } from 'wagmi'
import { formatEther } from 'viem'
import { contracts } from '../config/wagmi'
import { TripTokenABI, TripMarketplaceABI } from '../config/abis'

interface Listing {
  tokenId: bigint
  name: string
  substanceType: string
  potency: number
  duration: number
  price: bigint
  seller: string
}

interface Props {
  listing: Listing
  onBuySuccess?: () => void
}

export function MarketplaceListing({ listing, onBuySuccess }: Props) {
  const { address, isConnected } = useAccount()
  const [step, setStep] = useState<'idle' | 'approving' | 'buying'>('idle')

  const { writeContract: approve, data: approveHash } = useWriteContract()
  const { writeContract: buy, data: buyHash } = useWriteContract()

  const { isLoading: isApproving, isSuccess: approveSuccess } = useWaitForTransactionReceipt({ 
    hash: approveHash 
  })
  const { isLoading: isBuying, isSuccess: buySuccess } = useWaitForTransactionReceipt({ 
    hash: buyHash 
  })

  // Handle approve success -> trigger buy
  if (approveSuccess && step === 'approving') {
    setStep('buying')
    buy({
      address: contracts.tripMarketplace,
      abi: TripMarketplaceABI,
      functionName: 'buyPill',
      args: [listing.tokenId],
    })
  }

  // Handle buy success
  if (buySuccess && step === 'buying') {
    setStep('idle')
    onBuySuccess?.()
  }

  const handleBuy = () => {
    if (!isConnected) return
    
    setStep('approving')
    approve({
      address: contracts.tripToken,
      abi: TripTokenABI,
      functionName: 'approve',
      args: [contracts.tripMarketplace, listing.price],
    })
  }

  const isLoading = isApproving || isBuying
  const isSeller = address?.toLowerCase() === listing.seller.toLowerCase()

  return (
    <div className="group card-glow p-6 border border-neutral-800 rounded bg-[#0d0d0d] hover:border-green-500/30 transition-all duration-300">
      {/* Header */}
      <div className="flex justify-between items-start mb-4">
        <div className="text-2xl">🍄</div>
        <div className="font-terminal text-xs px-2 py-1 rounded bg-violet-500/20 text-violet-400">
          #{listing.tokenId.toString()}
        </div>
      </div>

      {/* Name & Type */}
      <h3 className="text-lg font-light mb-1 text-white font-terminal">{listing.name}</h3>
      <p className="text-neutral-500 text-xs mb-4 font-terminal">{listing.substanceType}</p>

      {/* Stats */}
      <div className="grid grid-cols-2 gap-2 font-terminal text-xs mb-4">
        <div>
          <span className="text-neutral-600">potency:</span>
          <span className="text-green-400 ml-2">{'█'.repeat(listing.potency)}{'░'.repeat(5-listing.potency)}</span>
        </div>
        <div>
          <span className="text-neutral-600">duration:</span>
          <span className="text-violet-400 ml-2">{Math.floor(listing.duration / 3600)}h</span>
        </div>
      </div>

      {/* Price */}
      <div className="border-t border-neutral-800 pt-4 mt-4">
        <div className="flex justify-between items-center mb-3">
          <span className="text-neutral-500 font-terminal text-xs">price:</span>
          <span className="text-green-400 font-terminal text-lg">
            {formatEther(listing.price)} $TRIP
          </span>
        </div>

        {/* Buy Button */}
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
              onClick={handleBuy}
              disabled={isLoading}
              className="w-full px-4 py-2 border border-green-500/50 rounded text-green-400 hover:bg-green-500/10 transition-all duration-300 font-terminal text-sm disabled:opacity-50"
            >
              {isApproving ? '[APPROVING...]' : isBuying ? '[BUYING...]' : '[BUY_NOW]'}
            </button>
          )
        ) : (
          <p className="text-neutral-500 font-terminal text-xs text-center">
            Connect wallet to buy
          </p>
        )}
      </div>
    </div>
  )
}
