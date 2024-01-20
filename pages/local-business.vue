<script setup lang="ts">
import * as fcl from '@onflow/fcl'
import type { Product } from '~/utils/types'

const res = await useFetch('https://fakestoreapi.com/products')
const products = ref<Product[]>(res.data.value as unknown as Product[])

async function buyProduct(cost: number) {
  const transaction = await fcl.mutate({
    cadence: `
    import FungibleToken from 0xFT
    import FlowToken from 0xDFT

    transaction(recipient: Address, amount: UFix64){
      prepare(signer: AuthAccount){
        let sender = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
          ?? panic("Could not borrow Provider reference to the Vault")

        let receiverAccount = getAccount(recipient)

        let receiver = receiverAccount.getCapability(/public/flowTokenReceiver)
          .borrow<&FlowToken.Vault{FungibleToken.Receiver}>()
          ?? panic("Could not borrow Receiver reference to the Vault")

                let tempVault <- sender.withdraw(amount: amount)
        receiver.deposit(from: <- tempVault)
      }
    }
        `,
    limit: 9999,
    // @ts-expect-error not sure how to type this
    args: (arg, t) => [
      arg('0x179b6b1cb6755e31', t.Address),
      arg(cost.toString(), t.UFix64),
    ],
    // @ts-expect-error not sure how to type this
    payer: fcl.authz,
    // @ts-expect-error not sure how to type this
    proposer: fcl.authz,
    // @ts-expect-error not sure how to type this
    authorizations: [fcl.authz],
  })

  await fcl.tx(transaction).onceSealed()
  consola.info('Product bought')
}
</script>

<template>
  <div h-full w-full flex flex-col gap-4>
    <div flex items-center justify-between>
      <h1 text-xl font-black>
        Buy & Support Local Businesses in your community
      </h1>
    </div>

    <div flex-1>
      <div grid grid-cols-5 gap-8>
        <div v-for="product in products" :key="product.id" flex flex-col justify-between px-4 py-4 border-2 rounded-md gap-2>
          <div
            h-48
            bg-center
            bg-contain
            :style="{
              backgroundImage: `url(${product.image})`,
            }"
          />

          <div class="text-sm text-center font-bold">
            {{ product.title }}
          </div>

          <div items-center justify-center text-center text-lime>
            {{ product.price }} $FLOW
          </div>

          <div>
            <button text-center bg-green-600 w-full py-2 rounded-md @click="buyProduct(product.price)">
              Buy
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
