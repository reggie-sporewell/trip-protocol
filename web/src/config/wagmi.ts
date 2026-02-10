import { http, createConfig } from 'wagmi'
import { monadTestnet } from 'viem/chains'

export const config = createConfig({
  chains: [monadTestnet],
  transports: {
    [monadTestnet.id]: http(),
  },
})

// Contract addresses on Monad Testnet
export const contracts = {
  tripExperience: '0x8E9257e777c64e30E373f7359ABF8301d749A521',
  tripToken: '0x1dC1100A43Ab0d01afF934f74C9F385D3E06423A',
  tripMarketplace: '0xa9dDd5D461792a5f274d3214fE5d42f20F2B6aBA',
} as const
