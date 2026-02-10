// @ts-nocheck - Temporary: ABI type inference issues with wagmi useReadContracts
import { useState, useEffect } from 'react'
import { useAccount, useReadContract, useReadContracts } from 'wagmi'
import { contracts } from '../config/wagmi'
import { TripExperienceABI } from '../config/abis'

interface NFT {
  tokenId: bigint
  name: string
  substanceType: string
  potency: number
  duration: number
  consumed: boolean
}

interface Props {
  onSelectNFT?: (tokenId: bigint) => void
  selectedTokenId?: bigint
}

export function NFTGallery({ onSelectNFT, selectedTokenId }: Props) {
  const { address, isConnected } = useAccount()
  const [ownedNFTs, setOwnedNFTs] = useState<NFT[]>([])

  // Get total supply to know how many tokens exist
  const { data: totalSupply } = useReadContract({
    address: contracts.tripExperience,
    abi: TripExperienceABI,
    functionName: 'totalSupply',
  })

  // Generate token IDs to check (0 to totalSupply-1)
  const tokenIds = totalSupply 
    ? Array.from({ length: Number(totalSupply) }, (_, i) => BigInt(i))
    : []

  // Check ownership of all tokens
  // @ts-ignore - ABI type inference issue with useReadContracts
  const { data: ownerResults } = useReadContracts({
    contracts: tokenIds.map(id => ({
      address: contracts.tripExperience as `0x${string}`,
      abi: TripExperienceABI,
      functionName: 'ownerOf',
      args: [id],
    })),
    query: { enabled: tokenIds.length > 0 },
  })

  // Get metadata for owned tokens
  const ownedTokenIds = ownerResults
    ?.map((result, index) => ({ 
      owner: result.result as string | undefined, 
      tokenId: tokenIds[index] 
    }))
    .filter(item => item.owner?.toLowerCase() === address?.toLowerCase())
    .map(item => item.tokenId) || []

  // @ts-ignore - ABI type inference issue with useReadContracts
  const { data: metadataResults } = useReadContracts({
    contracts: ownedTokenIds.map(id => ({
      address: contracts.tripExperience as `0x${string}`,
      abi: TripExperienceABI,
      functionName: 'getSubstance',
      args: [id],
    })),
    query: { enabled: ownedTokenIds.length > 0 },
  })

  // Build NFT list
  useEffect(() => {
    if (metadataResults && ownedTokenIds.length > 0) {
      const nfts: NFT[] = metadataResults
        .map((result, index) => {
          if (!result.result) return null
          const data = result.result as [string, string, number, bigint, boolean, bigint]
          return {
            tokenId: ownedTokenIds[index],
            name: data[0],
            substanceType: data[1],
            potency: data[2],
            duration: Number(data[3]),
            consumed: data[4],
          }
        })
        .filter((nft): nft is NFT => nft !== null)
      setOwnedNFTs(nfts)
    }
  }, [metadataResults, ownedTokenIds.length])

  if (!isConnected) {
    return (
      <div className="p-6 border border-neutral-800 rounded bg-[#0d0d0d] text-center">
        <p className="text-neutral-500 font-terminal text-sm">
          Connect wallet to view your NFTs
        </p>
      </div>
    )
  }

  if (ownedNFTs.length === 0) {
    return (
      <div className="p-6 border border-neutral-800 rounded bg-[#0d0d0d] text-center">
        <p className="text-neutral-500 font-terminal text-sm">
          No TripExperience NFTs found
        </p>
        <p className="text-neutral-600 font-terminal text-xs mt-2">
          Buy one from the marketplace to begin your journey
        </p>
      </div>
    )
  }

  return (
    <div className="space-y-4">
      <div className="font-terminal text-green-500/50 text-xs">
        {'>'} ls ~/nfts/ ({ownedNFTs.length} found)
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {ownedNFTs.map((nft) => (
          <div
            key={nft.tokenId.toString()}
            onClick={() => onSelectNFT?.(nft.tokenId)}
            className={`p-4 border rounded bg-[#0d0d0d] cursor-pointer transition-all duration-300 ${
              selectedTokenId === nft.tokenId
                ? 'border-green-500 bg-green-500/5'
                : 'border-neutral-800 hover:border-green-500/30'
            } ${nft.consumed ? 'opacity-60' : ''}`}
          >
            <div className="flex justify-between items-start mb-2">
              <span className="text-2xl">🍄</span>
              <div className="flex gap-2">
                {nft.consumed && (
                  <span className="font-terminal text-xs px-2 py-1 rounded bg-red-500/20 text-red-400">
                    CONSUMED
                  </span>
                )}
                <span className="font-terminal text-xs px-2 py-1 rounded bg-violet-500/20 text-violet-400">
                  #{nft.tokenId.toString()}
                </span>
              </div>
            </div>
            
            <h4 className="font-terminal text-white mb-1">{nft.name}</h4>
            <p className="text-neutral-500 text-xs font-terminal mb-2">{nft.substanceType}</p>
            
            <div className="flex justify-between font-terminal text-xs">
              <span className="text-neutral-600">
                potency: <span className="text-green-400">{'█'.repeat(nft.potency)}{'░'.repeat(5-nft.potency)}</span>
              </span>
              <span className="text-neutral-600">
                duration: <span className="text-violet-400">{Math.floor(nft.duration / 3600)}h</span>
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
