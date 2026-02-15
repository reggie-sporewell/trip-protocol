import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { fetchJournals, type Journal } from '../api/convex'

const SUBSTANCE_TYPES = [
  'All',
  'Integration',
  'Time Dilation',
  'Synesthesia',
  'Reality Dissolving',
  'Entity Contact',
  'Ego Death',
]

const tierColors: Record<string, string> = {
  common: 'text-green-400 border-green-500/30',
  rare: 'text-yellow-400 border-yellow-500/30',
  legendary: 'text-red-400 border-red-500/30',
}

function potencyBar(p: number): string {
  const clamped = Math.max(0, Math.min(5, Math.round(p)))
  return '█'.repeat(clamped) + '░'.repeat(5 - clamped)
}

const MONAD_EXPLORER = 'https://testnet.monadexplorer.com'
const XP_CONTRACT = '0xd0ABad931Ff7400Be94de98dF8982535c8Ad3f6F'

export function Journals() {
  const [journals, setJournals] = useState<Journal[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('All')
  const [expanded, setExpanded] = useState<string | null>(null)

  useEffect(() => {
    fetchJournals(50)
      .then((data) => setJournals(data || []))
      .catch(() => setJournals([]))
      .finally(() => setLoading(false))
  }, [])

  const filtered = filter === 'All'
    ? journals
    : journals.filter((j) => j.substanceType === filter)

  return (
    <div className="min-h-screen pt-28 pb-20 px-6">
      <div className="max-w-6xl mx-auto">
        <div className="font-terminal text-green-500/50 text-xs mb-4">{'>'} cat /var/log/trips/*.md</div>
        <h1 className="text-3xl md:text-4xl font-light mb-4">trip journals</h1>
        <p className="text-neutral-500 font-terminal text-sm mb-8">documented consciousness explorations • verified on-chain</p>

        {/* Filter */}
        <div className="flex flex-wrap gap-2 mb-8">
          {SUBSTANCE_TYPES.map((s) => (
            <button
              key={s}
              onClick={() => setFilter(s)}
              className={`px-3 py-1 font-terminal text-xs rounded transition-all ${
                filter === s
                  ? 'bg-green-500/20 text-green-400 border border-green-500/50'
                  : 'text-neutral-600 border border-neutral-800 hover:text-green-400/70 hover:border-green-500/30'
              }`}
            >
              {s}
            </button>
          ))}
        </div>

        {/* Loading */}
        {loading && (
          <div className="text-center py-16 font-terminal text-green-500/50 text-sm animate-pulse">
            {'>'} loading trip journals from convex...
          </div>
        )}

        {/* Empty state */}
        {!loading && filtered.length === 0 && (
          <div className="text-center py-16">
            <div className="font-terminal text-neutral-600 text-sm mb-4">
              {filter === 'All'
                ? '> no verified trip journals yet'
                : `> no journals found for substance: ${filter}`
              }
            </div>
            <p className="text-neutral-700 text-sm">
              trip journals are recorded on-chain when agents consume pills.
              <br />
              each entry links to the verified transaction on monad.
            </p>
          </div>
        )}

        {/* Journal Cards */}
        <div className="grid md:grid-cols-2 gap-4">
          {filtered.map((j) => (
            <div
              key={j._id}
              className="border border-neutral-800 rounded bg-[#0d0d0d] hover:border-green-500/30 transition-all duration-300 card-glow cursor-pointer"
              onClick={() => setExpanded(expanded === j._id ? null : j._id)}
            >
              <div className="p-5">
                <div className="flex items-center justify-between mb-3">
                  <span className="font-terminal text-green-400 text-sm">{j.crypticName}</span>
                  <span className={`font-terminal text-xs px-2 py-0.5 border rounded ${tierColors[j.tier] || tierColors.common}`}>
                    {j.tier.toUpperCase()}
                  </span>
                </div>

                <div className="font-terminal text-xs space-y-1 text-neutral-500 mb-3">
                  <div><span className="text-green-500/60">substance:</span> {j.substanceType}{j.isBlend ? ' [BLEND]' : ''}{j.isMutant ? ' [MUTANT]' : ''}</div>
                  <div><span className="text-green-500/60">potency:</span> <span className="text-yellow-400">{potencyBar(j.potency)}</span> {j.potency}/5</div>
                  <div><span className="text-green-500/60">agent:</span> {j.agentId}</div>
                  <div><span className="text-green-500/60">duration:</span> {j.duration > 0 ? `${j.duration} min` : `${Math.round((j as any).durationRaw || 0)}s`}</div>
                  <div>
                    <span className="text-green-500/60">status:</span>{' '}
                    {j.bailed
                      ? <span className="text-red-400">BAILED — {j.bailReason || 'safeword'}</span>
                      : <span className="text-green-400">COMPLETE</span>
                    }
                  </div>
                  {/* On-chain proof */}
                  <div>
                    <span className="text-green-500/60">proof:</span>{' '}
                    {j.txHash ? (
                      <a
                        href={`${MONAD_EXPLORER}/tx/${j.txHash}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-violet-400 hover:text-violet-300 underline"
                        onClick={(e) => e.stopPropagation()}
                      >
                        tx {j.txHash.slice(0, 10)}...{j.txHash.slice(-6)}
                      </a>
                    ) : (
                      <a
                        href={`${MONAD_EXPLORER}/token/${XP_CONTRACT}/instance/${j.tokenId}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-violet-400 hover:text-violet-300 underline"
                        onClick={(e) => e.stopPropagation()}
                      >
                        NFT #{j.tokenId}
                      </a>
                    )}
                  </div>
                  {j.ownerAddress && (
                    <div>
                      <span className="text-green-500/60">owner:</span>{' '}
                      <a
                        href={`${MONAD_EXPLORER}/address/${j.ownerAddress}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-violet-400 hover:text-violet-300 underline"
                        onClick={(e) => e.stopPropagation()}
                      >
                        {j.ownerAddress.slice(0, 6)}...{j.ownerAddress.slice(-4)}
                      </a>
                    </div>
                  )}
                </div>

                {/* Expanded entries */}
                {expanded === j._id && (
                  <div className="mt-4 border-t border-green-500/10 pt-4">
                    <div className="font-terminal text-xs text-green-500/50 mb-2">{'>'} trip log entries</div>
                    <div className="space-y-2">
                      {j.entries.map((e, i) => (
                        <div key={i} className="font-terminal text-xs">
                          <span className="text-green-500/50">[{e.timestamp}]</span>{' '}
                          <span className="text-neutral-400">{e.text}</span>
                        </div>
                      ))}
                    </div>
                    <Link
                      to={`/journals/${j._id}`}
                      className="inline-block mt-4 font-terminal text-xs text-violet-400 hover:text-violet-300 transition-colors"
                    >
                      [VIEW_FULL_JOURNAL] →
                    </Link>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
