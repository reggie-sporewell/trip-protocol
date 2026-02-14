import { useState, useEffect } from 'react'
import { useAccount } from 'wagmi'
import { useTripBalance, useTripFaucet, formatTrip } from '../hooks/useContracts'

export function TripFaucet() {
  const { address, isConnected } = useAccount()
  const { data: balance, refetch } = useTripBalance(address)
  const { claimFaucet, isPending, isConfirming, isSuccess, error } = useTripFaucet()
  const [showSuccess, setShowSuccess] = useState(false)
  const [prevBalance, setPrevBalance] = useState<string | null>(null)

  // Auto-refresh balance every 5 seconds while confirming or after success
  useEffect(() => {
    if (isConfirming || isSuccess) {
      const interval = setInterval(() => refetch(), 3000)
      return () => clearInterval(interval)
    }
  }, [isConfirming, isSuccess, refetch])

  // Show persistent success message
  useEffect(() => {
    if (isSuccess) {
      setShowSuccess(true)
      refetch()
      // Keep success visible for 15 seconds
      const timer = setTimeout(() => setShowSuccess(false), 15000)
      return () => clearTimeout(timer)
    }
  }, [isSuccess, refetch])

  // Track balance changes
  useEffect(() => {
    if (balance) {
      const formatted = formatTrip(balance as bigint)
      if (prevBalance && formatted !== prevBalance) {
        // Balance changed, trigger visual feedback
        setShowSuccess(true)
      }
      setPrevBalance(formatted)
    }
  }, [balance, prevBalance])

  const currentBalance = balance ? formatTrip(balance as bigint) : '0'

  if (!isConnected) {
    return (
      <div className="p-6 border border-neutral-800 rounded bg-[#0d0d0d]">
        <p className="text-neutral-500 font-terminal text-sm">
          {'>'} connect wallet to claim $TRIP
        </p>
      </div>
    )
  }

  return (
    <div className="p-6 border border-green-500/30 rounded bg-[#0d0d0d]">
      {/* Balance display - prominent */}
      <div className="mb-6 p-4 border border-green-500/20 rounded bg-green-500/5 text-center">
        <div className="font-terminal text-xs text-green-500/50 mb-1">YOUR $TRIP BALANCE</div>
        <div className={`font-terminal text-2xl transition-all duration-500 ${showSuccess ? 'text-green-300 scale-110' : 'text-green-400'}`}>
          {Number(currentBalance).toLocaleString()} TRIP
        </div>
        <div className="font-terminal text-xs text-neutral-600 mt-1">
          token: 0x8778...18a5 • Monad Testnet
        </div>
      </div>

      <p className="text-neutral-400 text-sm mb-4 font-terminal">
        {'>'} claim 1,000 $TRIP per request (1h cooldown)
      </p>

      <button
        onClick={claimFaucet}
        disabled={isPending || isConfirming}
        className="w-full px-4 py-3 border border-green-500/50 rounded text-green-400 hover:bg-green-500/10 transition-all duration-300 font-terminal text-sm disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {isPending
          ? '[SIGNING_TX...]'
          : isConfirming
            ? '[⏳ CONFIRMING_ON_CHAIN...]'
            : '[CLAIM_1000_TRIP]'}
      </button>

      {/* Success notification - persistent */}
      {showSuccess && (
        <div className="mt-4 p-3 border border-green-500/40 rounded bg-green-500/10 text-center animate-pulse">
          <p className="text-green-400 font-terminal text-sm">
            ✓ 1,000 $TRIP claimed successfully!
          </p>
          <p className="text-green-500/50 font-terminal text-xs mt-1">
            balance updated above
          </p>
        </div>
      )}

      {/* Confirming state */}
      {isConfirming && (
        <div className="mt-4 p-3 border border-yellow-500/30 rounded bg-yellow-500/5 text-center">
          <p className="text-yellow-400 font-terminal text-xs">
            ⏳ transaction submitted, waiting for confirmation...
          </p>
        </div>
      )}

      {error && (
        <div className="mt-4 p-3 border border-red-500/30 rounded bg-red-500/5 text-center">
          <p className="text-red-400 font-terminal text-xs">
            ✗ {error.message.includes('Wait 1h')
              ? 'cooldown active — wait 1 hour between claims'
              : error.message.slice(0, 80)}
          </p>
        </div>
      )}
    </div>
  )
}
