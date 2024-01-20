import { config } from '@onflow/fcl'
import { env } from 'std-env'
import flowJSON from '~/flow.json'

export const network: 'mainnet' | 'testnet' | 'emulator' = (env.PUBLIC_FLOW_NETWORK as
  | 'mainnet'
  | 'testnet'
  | 'emulator') || 'emulator'

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
  'app.detail.icon': '',
  'flow.network': network,
  'accessNode.api': fclConfigInfo[network].accessNode,
  'discovery.wallet': fclConfigInfo[network].discoveryWallet,
  'discovery.authn.include': fclConfigInfo[network].discoveryAuthInclude,
  // @ts-expect-error no idea
  '0xNC': `0x${flowJSON.accounts.default.address}` || NC_ADDRESS,
  '0xNCT': NCT_ADDRESS,
  '0xFT': FT_ADDRESS,
  '0xDFT': DFT_ADDRESS,
}).load({ flowJSON })
