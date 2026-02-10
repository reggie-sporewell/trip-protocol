import { useAccount, useConnect, useDisconnect } from 'wagmi'
import { injected } from 'wagmi/connectors'

export function WalletConnect() {
  const { address, isConnected } = useAccount()
  const { connect, isPending } = useConnect()
  const { disconnect } = useDisconnect()

  if (isConnected && address) {
    return (
      <div className="flex items-center gap-3">
        <span className="font-terminal text-xs text-green-400">
          {address.slice(0, 6)}...{address.slice(-4)}
        </span>
        <button
          onClick={() => disconnect()}
          className="px-3 py-1.5 border border-red-500/50 rounded text-red-400 hover:bg-red-500/10 transition-all duration-300 font-terminal text-xs"
        >
          [DISCONNECT]
        </button>
      </div>
    )
  }

  return (
    <button
      onClick={() => connect({ connector: injected() })}
      disabled={isPending}
      className="glitch-hover px-4 py-2 border border-green-500/50 rounded text-green-400 hover:bg-green-500/10 hover:border-green-400 transition-all duration-300 font-terminal text-sm disabled:opacity-50"
    >
      {isPending ? '[CONNECTING...]' : '[CONNECT_WALLET]'}
    </button>
  )
}
