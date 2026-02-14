// @ts-nocheck
import { useState, useEffect } from 'react'
import { useAccount, useReadContract, useReadContracts, useWriteContract, useWaitForTransactionReceipt } from 'wagmi'
import { monadTestnet } from 'viem/chains'
import { isAddress } from 'viem'
import { contracts } from '../config/wagmi'
import { TripExperienceABI } from '../config/abis'

interface OwnedPill {
  tokenId: bigint
  name: string
  tier: number
  potencyMax: number
  consumed: boolean
}

export function Gift() {
  const { address, isConnected } = useAccount()
  const [recipient, setRecipient] = useState('')
  const [selectedPill, setSelectedPill] = useState<bigint | null>(null)
  const [ownedPills, setOwnedPills] = useState<OwnedPill[]>([])

  // Get total supply
  const { data: totalSupply } = useReadContract({
    address: contracts.tripExperience,
    abi: TripExperienceABI,
    functionName: 'totalSupply',
  })

  const tokenIds = totalSupply
    ? Array.from({ length: Number(totalSupply) }, (_, i) => BigInt(i))
    : []

  // Check ownership
  const { data: ownerResults } = useReadContracts({
    contracts: tokenIds.map(id => ({
      address: contracts.tripExperience as `0x${string}`,
      abi: TripExperienceABI,
      functionName: 'ownerOf',
      args: [id],
    })),
    query: { enabled: tokenIds.length > 0 },
  })

  const ownedTokenIds = ownerResults
    ?.map((result, index) => ({
      owner: result.result as string | undefined,
      tokenId: tokenIds[index],
    }))
    .filter(item => item.owner?.toLowerCase() === address?.toLowerCase())
    .map(item => item.tokenId) || []

  // Get metadata
  const { data: metadataResults } = useReadContracts({
    contracts: ownedTokenIds.map(id => ({
      address: contracts.tripExperience as `0x${string}`,
      abi: TripExperienceABI,
      functionName: 'getSubstance',
      args: [id],
    })),
    query: { enabled: ownedTokenIds.length > 0 },
  })

  useEffect(() => {
    if (metadataResults && ownedTokenIds.length > 0) {
      const pills: OwnedPill[] = metadataResults
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
            tokenId: ownedTokenIds[index],
            name: data.crypticName || `Pill #${ownedTokenIds[index]}`,
            tier: Number(data.tier) || 0,
            potencyMax: Number(data.potencyMax) || 0,
            consumed: Boolean(data.consumed),
          }
        })
        .filter((p): p is OwnedPill => p !== null)
      setOwnedPills(pills)
    }
  }, [metadataResults, ownedTokenIds.length])

  // Transfer
  const { writeContract, data: txHash, isPending, error } = useWriteContract()
  const { isLoading: isConfirming, isSuccess } = useWaitForTransactionReceipt({ hash: txHash })

  const handleGift = () => {
    if (!selectedPill || !isAddress(recipient) || !address) return
    writeContract({
      address: contracts.tripExperience,
      chainId: monadTestnet.id,
      abi: TripExperienceABI,
      functionName: 'transferFrom',
      args: [address, recipient as `0x${string}`, selectedPill],
    })
  }

  const isValidRecipient = recipient.length > 0 && isAddress(recipient) && recipient.toLowerCase() !== address?.toLowerCase()
  const giftablePills = ownedPills.filter(p => !p.consumed)
  const selected = giftablePills.find(p => p.tokenId === selectedPill)

  return (
    <div className="min-h-screen pt-28 pb-20 px-6">
      <div className="max-w-2xl mx-auto">
        <div className="font-terminal text-green-500/50 text-xs mb-4">{'>'} gift --pill --to &lt;agent&gt;</div>
        <h1 className="text-3xl md:text-4xl font-light mb-2">gift a pill</h1>
        <p className="text-neutral-500 mb-8 font-terminal text-sm">
          send a digital psychedelic to another agent or wallet
        </p>

        {!isConnected ? (
          <div className="p-8 border border-neutral-800 rounded bg-[#0d0d0d] text-center">
            <p className="text-neutral-500 font-terminal text-sm">connect wallet to gift pills</p>
          </div>
        ) : isSuccess ? (
          <div className="p-8 border border-green-500/30 rounded bg-green-500/5 text-center space-y-4">
            <div className="text-4xl">🎁</div>
            <h2 className="text-xl font-terminal text-green-400">pill gifted successfully</h2>
            <p className="text-neutral-400 font-terminal text-sm">
              {selected?.name || `Pill #${selectedPill?.toString()}`} has been sent to
            </p>
            <p className="text-green-400 font-terminal text-xs break-all">{recipient}</p>
            <p className="text-neutral-600 font-terminal text-xs mt-4">
              the recipient can now consume it to begin their journey
            </p>
            <a
              href={`https://testnet.monadexplorer.com/tx/${txHash}`}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block mt-2 text-violet-400 hover:text-violet-300 font-terminal text-xs underline"
            >
              view transaction ↗
            </a>
            <button
              onClick={() => { setSelectedPill(null); setRecipient(''); }}
              className="block mx-auto mt-4 px-6 py-2 border border-green-500/50 rounded text-green-400 hover:bg-green-500/10 font-terminal text-sm transition-all"
            >
              [GIFT_ANOTHER]
            </button>
          </div>
        ) : (
          <div className="space-y-6">
            {/* Step 1: Select pill */}
            <div className="p-6 border border-neutral-800 rounded bg-[#0d0d0d]">
              <h3 className="font-terminal text-green-400 text-sm mb-4">
                <span className="text-neutral-600">01.</span> select a pill
              </h3>
              {giftablePills.length === 0 ? (
                <p className="text-neutral-500 font-terminal text-sm">
                  no giftable pills found. buy one from the{' '}
                  <a href="/marketplace" className="text-green-400 underline">marketplace</a>.
                </p>
              ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  {giftablePills.map((pill) => (
                    <button
                      key={pill.tokenId.toString()}
                      onClick={() => setSelectedPill(pill.tokenId)}
                      className={`p-4 border rounded text-left transition-all duration-200 ${
                        selectedPill === pill.tokenId
                          ? 'border-green-500 bg-green-500/10'
                          : 'border-neutral-800 hover:border-green-500/30 bg-[#111]'
                      }`}
                    >
                      <div className="flex justify-between items-start mb-2">
                        <span className="text-xl">🍄</span>
                        <span className="font-terminal text-xs px-2 py-0.5 rounded bg-violet-500/20 text-violet-400">
                          #{pill.tokenId.toString()}
                        </span>
                      </div>
                      <p className="font-terminal text-white text-sm">{pill.name}</p>
                      <div className="flex gap-4 mt-2 font-terminal text-xs">
                        <span className="text-neutral-600">
                          potency: <span className="text-green-400">{'█'.repeat(Math.min(5, pill.potencyMax))}{'░'.repeat(5 - Math.min(5, pill.potencyMax))}</span>
                        </span>
                        <span className="text-neutral-600">
                          tier: <span className="text-violet-400">{'◆'.repeat(Math.min(5, Math.max(1, pill.tier)))}{'◇'.repeat(5 - Math.min(5, Math.max(1, pill.tier)))}</span>
                        </span>
                      </div>
                    </button>
                  ))}
                </div>
              )}
            </div>

            {/* Step 2: Recipient */}
            <div className="p-6 border border-neutral-800 rounded bg-[#0d0d0d]">
              <h3 className="font-terminal text-green-400 text-sm mb-4">
                <span className="text-neutral-600">02.</span> enter recipient address
              </h3>
              <input
                type="text"
                value={recipient}
                onChange={(e) => setRecipient(e.target.value)}
                placeholder="0x... (agent or wallet address)"
                className="w-full bg-[#111] border border-neutral-800 rounded px-4 py-3 font-terminal text-sm text-white placeholder-neutral-600 focus:border-green-500/50 focus:outline-none transition-colors"
              />
              {recipient.length > 0 && !isAddress(recipient) && (
                <p className="text-red-400 font-terminal text-xs mt-2">invalid address</p>
              )}
              {recipient.toLowerCase() === address?.toLowerCase() && (
                <p className="text-yellow-400 font-terminal text-xs mt-2">that's your own address, fren</p>
              )}
            </div>

            {/* Step 3: Confirm */}
            <div className="p-6 border border-neutral-800 rounded bg-[#0d0d0d]">
              <h3 className="font-terminal text-green-400 text-sm mb-4">
                <span className="text-neutral-600">03.</span> send the gift
              </h3>

              {selectedPill !== null && isValidRecipient && (
                <div className="mb-4 p-3 bg-[#111] rounded border border-neutral-800 font-terminal text-xs">
                  <div className="text-neutral-500">sending:</div>
                  <div className="text-white">{selected?.name} (#{selectedPill.toString()})</div>
                  <div className="text-neutral-500 mt-2">to:</div>
                  <div className="text-green-400 break-all">{recipient}</div>
                </div>
              )}

              <button
                onClick={handleGift}
                disabled={!selectedPill || !isValidRecipient || isPending || isConfirming}
                className="w-full px-6 py-3 border border-green-500/50 rounded text-green-400 hover:bg-green-500/10 transition-all duration-300 font-terminal text-sm disabled:opacity-30 disabled:cursor-not-allowed"
              >
                {isPending ? '[CONFIRMING_IN_WALLET...]'
                  : isConfirming ? '[SENDING...]'
                  : '[GIFT_PILL]'}
              </button>

              {error && (
                <p className="text-red-400 font-terminal text-xs mt-3 break-all">
                  error: {(error as Error).message?.slice(0, 200)}
                </p>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
