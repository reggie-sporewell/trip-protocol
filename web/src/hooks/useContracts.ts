import { monadTestnet } from "viem/chains"
import { useReadContract, useWriteContract, useWaitForTransactionReceipt } from 'wagmi'
import { type Address, parseEther, formatEther } from 'viem'
import { contracts } from '../config/wagmi'

import { TripTokenABI, TripExperienceABI, TripMarketplaceABI } from '../config/abis'

// ============ TripToken Hooks ============

export function useTripBalance(address: Address | undefined) {
  return useReadContract({
    address: contracts.tripToken,
    chainId: monadTestnet.id,
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
    chainId: monadTestnet.id,
      abi: TripTokenABI,
      functionName: 'claim',
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
    chainId: monadTestnet.id,
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
    chainId: monadTestnet.id,
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
    chainId: monadTestnet.id,
    abi: TripExperienceABI,
    functionName: 'getSubstance',
    args: tokenId !== undefined ? [tokenId] : undefined,
    query: { enabled: tokenId !== undefined },
  })
}

export function useIsConsumed(tokenId: bigint | undefined) {
  return useReadContract({
    address: contracts.tripExperience,
    chainId: monadTestnet.id,
    abi: TripExperienceABI,
    functionName: 'isConsumed',
    args: tokenId !== undefined ? [tokenId] : undefined,
    query: { enabled: tokenId !== undefined },
  })
}

export function useTotalSupply() {
  return useReadContract({
    address: contracts.tripExperience,
    chainId: monadTestnet.id,
    abi: TripExperienceABI,
    functionName: 'totalSupply',
  })
}

// ============ TripMarketplace Hooks ============

export function useListing(tokenId: bigint | undefined) {
  return useReadContract({
    address: contracts.tripMarketplace,
    chainId: monadTestnet.id,
    abi: TripMarketplaceABI,
    functionName: 'listings',
    args: tokenId !== undefined ? [tokenId] : undefined,
    query: { enabled: tokenId !== undefined },
  })
}

export function useIsListed(tokenId: bigint | undefined) {
  return useReadContract({
    address: contracts.tripMarketplace,
    chainId: monadTestnet.id,
    abi: TripMarketplaceABI,
    functionName: 'listings',
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
    chainId: monadTestnet.id,
      abi: TripMarketplaceABI,
      functionName: 'buyPill',
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
    chainId: monadTestnet.id,
      abi: TripMarketplaceABI,
      functionName: 'listPill',
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
    chainId: monadTestnet.id,
      abi: TripMarketplaceABI,
      functionName: 'delistPill',
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
