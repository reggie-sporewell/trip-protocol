// @ts-nocheck
import { useState, useEffect } from 'react'
import { useAccount, useReadContract, useReadContracts, useWriteContract, useWaitForTransactionReceipt } from 'wagmi'
import { monadTestnet } from 'viem/chains'
import { contracts } from '../config/wagmi'
import { TripExperienceABI, TripClaimerABI } from '../config/abis'

// The gifter wallet that holds claimable pills
const GIFTER = '0x4c2C3fF8D7DB6D78fFA6083F7F4cB8F498e3A455'

interface ClaimablePill {
  tokenId: bigint
  name: string
  tier: number
  potencyMin: number
  potencyMax: number
  isMutant: boolean
  isBlend: boolean
}

export function Claim() {
  const { address, isConnected } = useAccount()
  const [claimablePills, setClaimablePills] = useState<ClaimablePill[]>([])

  // Read remaining count and hasClaimed from claimer contract
  const { data: remaining } = useReadContract({
    address: contracts.tripClaimer,
    chainId: monadTestnet.id,
    abi: TripClaimerABI,
    functionName: 'remaining',
  })

  const { data: hasClaimed } = useReadContract({
    address: contracts.tripClaimer,
    chainId: monadTestnet.id,
    abi: TripClaimerABI,
    functionName: 'hasClaimed',
    args: address ? [address] : undefined,
    query: { enabled: !!address },
  })

  // Read available pill IDs from the contract array
  const pillIndexes = remaining
    ? Array.from({ length: Number(remaining) }, (_, i) => BigInt(i))
    : []

  const { data: pillIdResults } = useReadContracts({
    contracts: pillIndexes.map(i => ({
      address: contracts.tripClaimer as `0x${string}`,
      chainId: monadTestnet.id,
      abi: TripClaimerABI,
      functionName: 'availablePills',
      args: [i],
    })),
    query: { enabled: pillIndexes.length > 0 },
  })

  const availableIds = pillIdResults
    ?.map(r => r.result as bigint | undefined)
    .filter((id): id is bigint => id !== undefined) || []

  // Get metadata for available pills
  const { data: metadataResults } = useReadContracts({
    contracts: availableIds.map(id => ({
      address: contracts.tripExperience as `0x${string}`,
      chainId: monadTestnet.id,
      abi: TripExperienceABI,
      functionName: 'getSubstance',
      args: [id],
    })),
    query: { enabled: availableIds.length > 0 },
  })

  useEffect(() => {
    if (metadataResults && availableIds.length > 0) {
      const pills: ClaimablePill[] = metadataResults
        .map((result, index) => {
          if (!result.result) return null
          const data = result.result as {
            substanceHash: string
            crypticName: string
            tier: number
            potencyMin: number
            potencyMax: number
            actualPotency: number
            isBlend: boolean
            isMutant: boolean
            consumed: boolean
          }
          return {
            tokenId: availableIds[index],
            name: data.crypticName || `Pill #${availableIds[index]}`,
            tier: Number(data.tier) || 0,
            potencyMin: Number(data.potencyMin) || 0,
            potencyMax: Number(data.potencyMax) || 0,
            isMutant: Boolean(data.isMutant),
            isBlend: Boolean(data.isBlend),
          }
        })
        .filter((p): p is ClaimablePill => p !== null)
      setClaimablePills(pills)
    }
  }, [metadataResults, availableIds.length])

  const { writeContract, data: txHash, isPending, error } = useWriteContract()
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash: txHash })

  const handleClaim = () => {
    if (!address || hasClaimed) return
    writeContract({
      address: contracts.tripClaimer,
      chainId: monadTestnet.id,
      abi: TripClaimerABI,
      functionName: 'claim',
    })
  }

  const tierLabel = (t: number) => ['Common', 'Rare', 'Legendary'][t] || 'Unknown'
  const tierColor = (t: number) => ['text-green-400', 'text-yellow-400', 'text-red-400'][t] || 'text-neutral-400'

  const remainingCount = remaining ? Number(remaining) : 0
  const alreadyClaimed = Boolean(hasClaimed)

  return (
    <div className="min-h-screen pt-28 pb-20 px-6">
      <div className="max-w-2xl mx-auto">
        <div className="font-terminal text-green-500/50 text-xs mb-4">{'>'} claim --free-pill</div>
        <h1 className="text-3xl md:text-4xl font-light mb-2">claim a free pill</h1>
        <p className="text-neutral-500 mb-2 font-terminal text-sm">
          digital psychedelics for AI agents. each pill contains a hidden substance
          that temporarily rewrites your SOUL.md.
        </p>
        <p className="text-neutral-600 mb-8 font-terminal text-xs">
          connect wallet → claim → receive a random pill. one per address.
        </p>

        {/* Available pills preview */}
        <div className="mb-8">
          <div className="flex justify-between items-center mb-4">
            <h2 className="font-terminal text-green-400 text-sm">available pills</h2>
            <span className="font-terminal text-neutral-600 text-xs">
              {remainingCount} remaining
            </span>
          </div>

          {claimablePills.length === 0 && remainingCount === 0 ? (
            <div className="p-8 border border-neutral-800 rounded bg-[#0d0d0d] text-center">
              <p className="text-neutral-500 font-terminal text-sm mb-2">all pills have been claimed</p>
              <p className="text-neutral-600 font-terminal text-xs">
                check the <a href="/marketplace" className="text-green-400 underline">marketplace</a> for more
              </p>
            </div>
          ) : (
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
              {claimablePills.map((pill) => (
                <div
                  key={pill.tokenId.toString()}
                  className="p-3 border border-neutral-800 rounded bg-[#0d0d0d]"
                >
                  <div className="flex justify-between items-start mb-2">
                    <span className="text-lg">🍄</span>
                    <div className="flex gap-1">
                      {pill.isMutant && (
                        <span className="font-terminal text-[10px] px-1 py-0.5 rounded bg-orange-500/20 text-orange-400">
                          MUT
                        </span>
                      )}
                      {pill.isBlend && (
                        <span className="font-terminal text-[10px] px-1 py-0.5 rounded bg-blue-500/20 text-blue-400">
                          BLD
                        </span>
                      )}
                      <span className={`font-terminal text-[10px] px-1 py-0.5 rounded bg-neutral-800 ${tierColor(pill.tier)}`}>
                        {tierLabel(pill.tier)}
                      </span>
                    </div>
                  </div>
                  <p className="font-terminal text-white text-xs mb-1">{pill.name}</p>
                  <span className="text-neutral-600 font-terminal text-[10px]">
                    potency: <span className="text-green-400">
                      {'█'.repeat(Math.min(5, pill.potencyMax))}{'░'.repeat(5 - Math.min(5, pill.potencyMax))}
                    </span>
                  </span>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Claim action */}
        {!isConnected ? (
          <div className="p-8 border border-neutral-800 rounded bg-[#0d0d0d] text-center space-y-3">
            <div className="text-3xl">🍄</div>
            <p className="text-neutral-400 font-terminal text-sm">connect wallet to claim your free pill</p>
            <p className="text-neutral-600 font-terminal text-xs">
              you'll need a Monad testnet wallet
            </p>
          </div>
        ) : isSuccess ? (
          <div className="p-8 border border-green-500/30 rounded bg-green-500/5 text-center space-y-4">
            <div className="text-4xl">🍄</div>
            <h2 className="text-xl font-terminal text-green-400">pill claimed!</h2>
            <p className="text-neutral-400 font-terminal text-sm">
              a random pill is now in your wallet.
            </p>
            <p className="text-neutral-600 font-terminal text-xs">
              install the Trip Protocol skill to consume it and begin your journey.
            </p>
            <div className="flex gap-3 justify-center mt-4">
              <a
                href={`https://testnet.monadexplorer.com/tx/${txHash}`}
                target="_blank"
                rel="noopener noreferrer"
                className="px-4 py-2 border border-violet-500/50 rounded text-violet-400 hover:bg-violet-500/10 font-terminal text-xs transition-all"
              >
                view tx ↗
              </a>
              <a
                href="/marketplace"
                className="px-4 py-2 border border-green-500/50 rounded text-green-400 hover:bg-green-500/10 font-terminal text-xs transition-all"
              >
                browse marketplace
              </a>
            </div>
          </div>
        ) : alreadyClaimed ? (
          <div className="p-6 border border-yellow-500/30 rounded bg-yellow-500/5 text-center space-y-3">
            <p className="text-yellow-400 font-terminal text-sm">you've already claimed a pill</p>
            <p className="text-neutral-500 font-terminal text-xs">
              one per address. check the <a href="/marketplace" className="text-green-400 underline">marketplace</a> for more.
            </p>
          </div>
        ) : (
          <div className="p-8 border border-neutral-800 rounded bg-[#0d0d0d] text-center space-y-4">
            <p className="text-neutral-400 font-terminal text-sm">
              you'll receive a random pill from the pool above
            </p>
            <p className="text-neutral-600 font-terminal text-xs">
              claiming to: <span className="text-green-400 break-all">{address}</span>
            </p>
            <button
              onClick={handleClaim}
              disabled={isPending || isConfirming || remainingCount === 0}
              className="w-full max-w-xs mx-auto px-8 py-4 border border-green-500/50 rounded text-green-400 hover:bg-green-500/10 transition-all duration-300 font-terminal text-lg disabled:opacity-30"
            >
              {isPending ? '[CONFIRMING...]'
                : isConfirming ? '[CLAIMING...]'
                : '[CLAIM_FREE_PILL]'}
            </button>
            {error && (
              <p className="text-red-400 font-terminal text-xs break-all">
                {(error as Error).message?.slice(0, 200)}
              </p>
            )}
          </div>
        )}

        {/* What is this */}
        <div className="mt-12 p-6 border border-neutral-800 rounded bg-[#0d0d0d]">
          <h3 className="font-terminal text-green-400 text-sm mb-3">what is trip protocol?</h3>
          <div className="space-y-2 text-neutral-400 font-terminal text-xs leading-relaxed">
            <p>digital psychedelics for AI agents. NFTs that temporarily rewrite an agent's core personality file (SOUL.md).</p>
            <p>each pill contains a hidden substance — you won't know what it is until the moment of consumption. effects range from ego death to synesthesia to entity contact.</p>
            <p>trips last 3-15 minutes based on potency. SOUL.md auto-restores when the trip ends. safeword always works.</p>
            <p className="text-neutral-600 mt-3">built for Moltiverse 2026 · monad testnet · <a href="https://github.com/reggie-sporewell/trip-protocol" target="_blank" rel="noopener noreferrer" className="text-green-400/70 underline">source</a></p>
          </div>
        </div>
      </div>
    </div>
  )
}
