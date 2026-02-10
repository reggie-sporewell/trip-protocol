import { useState, useEffect } from 'react'
import { useAccount, useWriteContract, useWaitForTransactionReceipt } from 'wagmi'
import { parseEther } from 'viem'
import { contracts } from '../config/wagmi'
import { NFTGallery } from './NFTGallery'
import { TripExperienceABI, TripMarketplaceABI } from '../config/abis'

interface Props {
  onListSuccess?: () => void
}

export function ListNFT({ onListSuccess }: Props) {
  const { isConnected } = useAccount()
  const [selectedTokenId, setSelectedTokenId] = useState<bigint | undefined>()
  const [price, setPrice] = useState('')
  const [step, setStep] = useState<'idle' | 'approving' | 'listing'>('idle')
  const [error, setError] = useState<string | null>(null)

  const { writeContract: approve, data: approveHash, error: approveError } = useWriteContract()
  const { writeContract: list, data: listHash, error: listError } = useWriteContract()

  const { isLoading: isApproving, isSuccess: approveSuccess } = useWaitForTransactionReceipt({ 
    hash: approveHash 
  })
  const { isLoading: isListing, isSuccess: listSuccess } = useWaitForTransactionReceipt({ 
    hash: listHash 
  })

  // Handle approve -> list
  useEffect(() => {
    if (approveSuccess && step === 'approving' && selectedTokenId !== undefined) {
      setStep('listing')
      list({
        address: contracts.tripMarketplace,
        abi: TripMarketplaceABI,
        functionName: 'list',
        args: [selectedTokenId, parseEther(price)],
      })
    }
  }, [approveSuccess, step, selectedTokenId, price])

  // Handle list success
  useEffect(() => {
    if (listSuccess && step === 'listing') {
      setStep('idle')
      setSelectedTokenId(undefined)
      setPrice('')
      onListSuccess?.()
    }
  }, [listSuccess, step])

  // Handle errors
  useEffect(() => {
    if (approveError) {
      setError(approveError.message.slice(0, 100))
      setStep('idle')
    }
    if (listError) {
      setError(listError.message.slice(0, 100))
      setStep('idle')
    }
  }, [approveError, listError])

  const handleList = () => {
    if (!isConnected || selectedTokenId === undefined || !price) return
    
    setError(null)
    setStep('approving')
    
    // Approve marketplace to transfer NFT
    approve({
      address: contracts.tripExperience,
      abi: TripExperienceABI,
      functionName: 'approve',
      args: [contracts.tripMarketplace, selectedTokenId],
    })
  }

  const isProcessing = isApproving || isListing
  const canList = selectedTokenId !== undefined && price && parseFloat(price) > 0

  if (!isConnected) {
    return (
      <div className="p-6 border border-neutral-800 rounded bg-[#0d0d0d] text-center">
        <p className="text-neutral-500 font-terminal text-sm">
          Connect wallet to list NFTs
        </p>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div className="font-terminal text-green-500/50 text-xs">
        {'>'} list_nft --select --price
      </div>

      {/* Step 1: Select NFT */}
      <div>
        <h4 className="font-terminal text-neutral-400 text-sm mb-3">1. Select NFT to list</h4>
        <NFTGallery 
          onSelectNFT={setSelectedTokenId} 
          selectedTokenId={selectedTokenId}
        />
      </div>

      {/* Step 2: Set Price */}
      {selectedTokenId !== undefined && (
        <div className="border border-green-500/20 rounded p-4 bg-green-500/5">
          <h4 className="font-terminal text-neutral-400 text-sm mb-3">
            2. Set price for #{selectedTokenId.toString()}
          </h4>
          
          <div className="flex gap-3">
            <input
              type="number"
              min="0"
              step="0.01"
              value={price}
              onChange={(e) => setPrice(e.target.value)}
              placeholder="100"
              className="flex-1 px-4 py-2 bg-[#0d0d0d] border border-neutral-700 rounded text-white font-terminal text-sm focus:border-green-500/50 focus:outline-none"
            />
            <span className="px-4 py-2 text-green-400 font-terminal text-sm">
              $TRIP
            </span>
          </div>

          <button
            onClick={handleList}
            disabled={!canList || isProcessing}
            className="w-full mt-4 px-4 py-3 border border-green-500/50 rounded text-green-400 hover:bg-green-500/10 transition-all duration-300 font-terminal text-sm disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isApproving 
              ? '[APPROVING_NFT...]' 
              : isListing 
                ? '[LISTING...]' 
                : '[LIST_FOR_SALE]'
            }
          </button>

          {error && (
            <p className="mt-3 text-red-400 font-terminal text-xs text-center">
              Error: {error}
            </p>
          )}

          {listSuccess && (
            <p className="mt-3 text-green-400 font-terminal text-xs text-center">
              ✓ NFT listed successfully!
            </p>
          )}
        </div>
      )}
    </div>
  )
}
