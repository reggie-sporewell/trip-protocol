import { http, createConfig } from 'wagmi'
import { monad } from 'viem/chains'

export const config = createConfig({
  chains: [monad],
  transports: {
    [monad.id]: http(),
  },
})

// Contract addresses on Monad Mainnet
export const contracts = {
  tripExperience: '0xa9dDd5D461792a5f274d3214fE5d42f20F2B6aBA',
  tripToken: '0x6a02d66397d7BAb14149Bca486642B70e29A7777',
  tripMarketplace: '0xC50616c003259dEAF672a697Ec337edA436A9537',
  tripClaimer: '0x7356eCE081ba22513409f5FF0b616ED62eDd2a03',
} as const
