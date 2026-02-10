import { useReadContract, useWriteContract, useWaitForTransactionReceipt } from 'wagmi'
import { type Address, parseEther, formatEther } from 'viem'
import { contracts } from '../config/wagmi'

import TripTokenABI from '../config/abis/TripToken.json'
import TripExperienceABI from '../config/abis/TripExperience.json'
import TripMarketplaceABI from '../config/abis/TripMarketplace.json'

// ============ TripToken Hooks ============

export function useTripBalance(address: Address | undefined) {
  return useReadContract({
    address: contracts.tripToken,
    abi: TripTokenABI,
    functionName: 'balanceOf',
    args: address ? [address] : undefined,
    query: { enabled: !!address },
  })
}

export function useTripFaucet() {
  const { writeContract, data: hash, isPending, error } = useWriteContract()
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash })

  const claimFaucet = () => {
    writeContract({
      address: contracts.tripToken,
      abi: TripTokenABI,
      functionName: 'faucet',
    })
  }

  return { claimFaucet, isPending, isConfirming, isSuccess, error, hash }
}

export function useTripApprove(spender: Address, amount: bigint) {
  const { writeContract, data: hash, isPending, error } = useWriteContract()
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash })

  const approve = () => {
    writeContract({
      address: contracts.tripToken,
      abi: TripTokenABI,
      functionName: 'approve',
      args: [spender, amount],
    })
  }

  return { approve, isPending, isConfirming, isSuccess, error, hash }
}

// ============ TripExperience Hooks ============

export function useOwnedNFTs(address: Address | undefined) {
  // Note: This is a simplified approach. For production, use an indexer or events.
  const { data: balance } = useReadContract({
    address: contracts.tripExperience,
    abi: TripExperienceABI,
    functionName: 'balanceOf',
    args: address ? [address] : undefined,
    query: { enabled: !!address },
  })

  return { balance: balance as bigint | undefined }
}

export function useNFTMetadata(tokenId: bigint | undefined) {
  return useReadContract({
    address: contracts.tripExperience,
    abi: TripExperienceABI,
    functionName: 'getSubstance',
    args: tokenId !== undefined ? [tokenId] : undefined,
    query: { enabled: tokenId !== undefined },
  })
}

export function useIsConsumed(tokenId: bigint | undefined) {
  return useReadContract({
    address: contracts.tripExperience,
    abi: TripExperienceABI,
    functionName: 'isConsumed',
    args: tokenId !== undefined ? [tokenId] : undefined,
    query: { enabled: tokenId !== undefined },
  })
}

export function useTotalSupply() {
  return useReadContract({
    address: contracts.tripExperience,
    abi: TripExperienceABI,
    functionName: 'totalSupply',
  })
}

// ============ TripMarketplace Hooks ============

export function useListing(tokenId: bigint | undefined) {
  return useReadContract({
    address: contracts.tripMarketplace,
    abi: TripMarketplaceABI,
    functionName: 'getListing',
    args: tokenId !== undefined ? [tokenId] : undefined,
    query: { enabled: tokenId !== undefined },
  })
}

export function useIsListed(tokenId: bigint | undefined) {
  return useReadContract({
    address: contracts.tripMarketplace,
    abi: TripMarketplaceABI,
    functionName: 'isListed',
    args: tokenId !== undefined ? [tokenId] : undefined,
    query: { enabled: tokenId !== undefined },
  })
}

export function useBuyNFT() {
  const { writeContract, data: hash, isPending, error } = useWriteContract()
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash })

  const buy = (tokenId: bigint) => {
    writeContract({
      address: contracts.tripMarketplace,
      abi: TripMarketplaceABI,
      functionName: 'buy',
      args: [tokenId],
    })
  }

  return { buy, isPending, isConfirming, isSuccess, error, hash }
}

export function useListNFT() {
  const { writeContract, data: hash, isPending, error } = useWriteContract()
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash })

  const list = (tokenId: bigint, price: bigint) => {
    writeContract({
      address: contracts.tripMarketplace,
      abi: TripMarketplaceABI,
      functionName: 'list',
      args: [tokenId, price],
    })
  }

  return { list, isPending, isConfirming, isSuccess, error, hash }
}

export function useDelistNFT() {
  const { writeContract, data: hash, isPending, error } = useWriteContract()
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash })

  const delist = (tokenId: bigint) => {
    writeContract({
      address: contracts.tripMarketplace,
      abi: TripMarketplaceABI,
      functionName: 'delist',
      args: [tokenId],
    })
  }

  return { delist, isPending, isConfirming, isSuccess, error, hash }
}

// ============ Helper Functions ============

export function formatTrip(amount: bigint | undefined): string {
  if (!amount) return '0'
  return formatEther(amount)
}

export function parseTrip(amount: string): bigint {
  return parseEther(amount)
}
