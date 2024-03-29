import { config } from '@onflow/fcl'
import flowJSON from '~/flow.json'

export const network: 'mainnet' | 'testnet' | 'emulator' = 'testnet'

const fclConfigInfo = {
  emulator: {
    accessNode: 'http://127.0.0.1:8888',
    discoveryWallet: 'http://localhost:8701/fcl/authn',
    discoveryAuthInclude: [],
  },
  testnet: {
    accessNode: 'https://rest-testnet.onflow.org',
    discoveryWallet: 'https://fcl-discovery.onflow.org/testnet/authn',
    discoveryAuthInclude: [],
  },
  mainnet: {
    accessNode: 'https://rest-mainnet.onflow.org',
    discoveryWallet: 'https://fcl-discovery.onflow.org/authn',
    discoveryAuthInclude: [],
  },
}

const { NC_ADDRESS, NCT_ADDRESS, FT_ADDRESS, DFT_ADDRESS } = useRuntimeConfig().public

config({
  'app.detail.title': 'Sarpanch',
  'app.detail.icon': 'https://pycz.dev/favicon.svg',
  'flow.network': network,
  'accessNode.api': fclConfigInfo[network].accessNode,
  'discovery.wallet': fclConfigInfo[network].discoveryWallet,
  'discovery.authn.include': fclConfigInfo[network].discoveryAuthInclude,
  '0xNC': NC_ADDRESS,
  '0xNCT': NCT_ADDRESS,
  '0xFT': FT_ADDRESS,
  '0xDFT': DFT_ADDRESS,
}).load({ flowJSON })
