import { useAccount } from 'wagmi'
import { useTripBalance, useTripFaucet, formatTrip } from '../hooks/useContracts'

export function TripFaucet() {
  const { address, isConnected } = useAccount()
  const { data: balance, refetch } = useTripBalance(address)
  const { claimFaucet, isPending, isConfirming, isSuccess, error } = useTripFaucet()

  // Refetch balance after successful claim
  if (isSuccess) {
    setTimeout(() => refetch(), 2000)
  }

  if (!isConnected) {
    return (
      <div className="p-6 border border-neutral-800 rounded bg-[#0d0d0d]">
        <p className="text-neutral-500 font-terminal text-sm">
          Connect wallet to claim $TRIP
        </p>
      </div>
    )
  }

  return (
    <div className="p-6 border border-green-500/30 rounded bg-[#0d0d0d]">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-lg font-terminal text-green-400">$TRIP Faucet</h3>
        <div className="font-terminal text-sm">
          <span className="text-neutral-500">Balance: </span>
          <span className="text-green-400">
            {balance ? formatTrip(balance as bigint) : '0'} TRIP
          </span>
        </div>
      </div>

      <p className="text-neutral-400 text-sm mb-4">
        Claim 1,000 $TRIP tokens for testing. No limits on testnet.
      </p>

      <button
        onClick={claimFaucet}
        disabled={isPending || isConfirming}
        className="w-full px-4 py-3 border border-green-500/50 rounded text-green-400 hover:bg-green-500/10 transition-all duration-300 font-terminal text-sm disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {isPending ? '[SIGNING...]' : isConfirming ? '[CONFIRMING...]' : '[CLAIM_1000_TRIP]'}
      </button>

      {isSuccess && (
        <p className="mt-3 text-green-400 font-terminal text-xs text-center">
          ✓ Claimed 1,000 $TRIP!
        </p>
      )}

      {error && (
        <p className="mt-3 text-red-400 font-terminal text-xs text-center">
          Error: {error.message.slice(0, 50)}...
        </p>
      )}
    </div>
  )
}
