import { useState } from 'react'
import { Marketplace } from '../components/Marketplace'
import { NFTGallery } from '../components/NFTGallery'
import { ListNFT } from '../components/ListNFT'
import { TripFaucet } from '../components/TripFaucet'
import { HowItWorksModal } from '../components/HowItWorksModal'

export function MarketplacePage() {
  const [activeTab, setActiveTab] = useState<'browse' | 'my-nfts' | 'list' | 'faucet'>('browse')

  return (
    <div className="min-h-screen pt-28 pb-20 px-6">
      <div className="max-w-6xl mx-auto">
        <div className="font-terminal text-green-500/50 text-xs mb-4">{'>'} ls -la /marketplace/</div>
        <h1 className="text-3xl md:text-4xl font-light mb-4">the marketplace</h1>
        <div className="flex items-center gap-4 mb-8">
          <p className="text-neutral-500 font-terminal text-sm">buy, sell, and collect digital psychedelics</p>
          <HowItWorksModal />
        </div>

        {/* Tabs */}
        <div className="flex gap-2 mb-8 border-b border-neutral-800 pb-4">
          {([
            { key: 'browse' as const, label: '[BROWSE]', accent: 'green' },
            { key: 'my-nfts' as const, label: '[MY_NFTS]', accent: 'green' },
            { key: 'list' as const, label: '[LIST_FOR_SALE]', accent: 'green' },
            { key: 'faucet' as const, label: '[$TRIP_FAUCET]', accent: 'violet' },
          ]).map((tab) => (
            <button
              key={tab.key}
              onClick={() => setActiveTab(tab.key)}
              className={`px-4 py-2 font-terminal text-sm rounded transition-all ${
                activeTab === tab.key
                  ? tab.accent === 'violet'
                    ? 'bg-violet-500/20 text-violet-400 border border-violet-500/50'
                    : 'bg-green-500/20 text-green-400 border border-green-500/50'
                  : tab.accent === 'violet'
                    ? 'text-neutral-500 hover:text-violet-400'
                    : 'text-neutral-500 hover:text-green-400'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {activeTab === 'browse' && (
          <div>
            <div className="font-terminal text-green-500/50 text-xs mb-4">{'>'} browse active listings</div>
            <Marketplace />
          </div>
        )}
        {activeTab === 'my-nfts' && (
          <div>
            <div className="font-terminal text-green-500/50 text-xs mb-4">{'>'} ls ~/nfts/</div>
            <NFTGallery />
          </div>
        )}
        {activeTab === 'list' && (
          <div>
            <div className="font-terminal text-green-500/50 text-xs mb-4">{'>'} list_nft --interactive</div>
            <ListNFT onListSuccess={() => setActiveTab('browse')} />
          </div>
        )}
        {activeTab === 'faucet' && (
          <div className="max-w-md">
            <div className="font-terminal text-green-500/50 text-xs mb-4">{'>'} claim_tokens --amount 1000</div>
            <TripFaucet />
          </div>
        )}
      </div>
    </div>
  )
}
