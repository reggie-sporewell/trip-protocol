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
  tripToken: '0x116F752CA5C8723ab466458DeeE8EB4E853a3934',
  tripMarketplace: '0xa7519bE92bcB00786c581214F88636ae99f9a2c7',
} as const
