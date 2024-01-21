import { z } from 'zod'
import * as fcl from '@onflow/fcl'
import { config } from '@onflow/fcl'
import { env } from 'std-env'
import { publicProcedure, router } from '../trpc'
import { signFromServer } from '~/server/utils/sign'

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

const { NC_ADDRESS, NCT_ADDRESS, FT_ADDRESS, DFT_ADDRESS } = env

config({
  'app.detail.title': 'Sarpanch',
  'app.detail.icon': '',
  'flow.network': network,
  'accessNode.api': fclConfigInfo[network].accessNode,
  'discovery.wallet': fclConfigInfo[network].discoveryWallet,
  'discovery.authn.include': fclConfigInfo[network].discoveryAuthInclude,
  '0xNC': NC_ADDRESS,
  '0xNCT': NCT_ADDRESS,
  '0xFT': FT_ADDRESS,
  '0xDFT': DFT_ADDRESS,
}).load({ flowJSON })

export const flowRouter = router({
  mint: publicProcedure
    .input(z.object({
      address: z.string(),
    }))
    .mutation(async ({ input }) => {
      const transaction = await fcl.mutate({
        cadence: `
        import FungibleToken from 0xFT
import SamuhikaToken from 0xNC

transaction(recipient: Address, amount: UFix64) {
    let Minter: &SamuhikaToken.Minter

    let TokenReceiver: &SamuhikaToken.Vault{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.Minter = signer.borrow<&SamuhikaToken.Minter>(from: SamuhikaToken.MinterStoragePath)
            ?? panic("signature possibly from wrong account")

        self.TokenReceiver = getAccount(recipient).getCapability(SamuhikaToken.VaultReceiverPath)
                              .borrow<&SamuhikaToken.Vault{FungibleToken.Receiver}>()
                              ?? panic("borrow receiver reference error")
    }

    execute {
        let mintedVault <- self.Minter.mintTokens(amount: amount)
        self.TokenReceiver.deposit(from: <-mintedVault)
    }
}
`,
        // @ts-expect-error no typings for fcl
        args: (arg, t) => [
          arg(input.address, t.Address),
          arg('1000.00', t.UFix64),
        ],
        proposer: signFromServer,
        payer: signFromServer,
        authorizations: [signFromServer],
        limit: 999,
      })

      return transaction
    }),
})
