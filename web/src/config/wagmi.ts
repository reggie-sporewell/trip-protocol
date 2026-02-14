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
  tripExperience: '0xd0ABad931Ff7400Be94de98dF8982535c8Ad3f6F',
  tripToken: '0x8778A08B825B12dA6bFF09d5dE2E3a19B9bA18a5',
  tripMarketplace: '0x4c5f7022e0f6675627e2d66fe8d615c71f8878f8',
} as const
