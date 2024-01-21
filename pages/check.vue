<script setup lang="ts">
import * as fcl from '@onflow/fcl'
import type { Transaction } from '@onflow/typedefs'
import SetupSamuhikaTokenVault from '~/cadence/SamuhikaTokenUtils/setupVault.cdc?raw'
import GetSamuhikaTokenBalance from '~/cadence/scripts/getSamuhikaTokenBalance.cdc?raw'
import DepositToTreasury from '~/cadence/transactions/depositTokensToTreasury.cdc?raw'
import { TransactionModals } from '~/utils/store'

const router = useRouter()

const balance = ref(0)
const isChecking = ref(true)
// const isAccountReady = ref<boolean | null>(null)
const { NC_ADDRESS } = useRuntimeConfig().public

if (!userData.value?.addr)
  router.push('/')

async function getBalance() {
  if (!userData.value?.addr)
    return router.push('/')

  const response = await fcl.query({
    cadence: GetSamuhikaTokenBalance,
    // @ts-expect-error no typings for fcl
    args: (arg, t) => [arg(userData.value!.addr, t.Address)],
  })

  balance.value = response
  isChecking.value = false
}

async function pledgeTokens() {
  if (!userData.value?.addr)
    return router.push('/')

  const transaction = await fcl.mutate({
    cadence: DepositToTreasury,
    // @ts-expect-error no typings for fcl
    args: (arg, t) => [
      arg(NC_ADDRESS, t.Address),
      arg('1000.00', t.UFix64),
      arg('Pledge to SarpanchDAO', t.String),
    ],
    // @ts-expect-error no typings for fcl
    proposer: fcl.authz,
    // @ts-expect-error no typings for fcl
    payer: fcl.authz,
    // @ts-expect-error no typings for fcl
    authorizations: [fcl.authz],
    limit: 999,

  })

  TransactionModals.value.push({
    title: 'Txn for Pledging $FLOW to SarpanchDAO',
    transactionId: transaction,
  })

  consola.info('transaction', transaction)
  await fcl.tx(transaction).onceSealed()
}

async function setupAccount() {
  if (!userData.value?.addr)
    return router.push('/')

  const transaction = await fcl.mutate({
    cadence: SetupSamuhikaTokenVault,
    args: () => [],
    // @ts-expect-error no typings for fcl
    proposer: fcl.authz,
    // @ts-expect-error no typings for fcl
    payer: fcl.authz,
    // @ts-expect-error no typings for fcl
    authorizations: [fcl.authz],
    limit: 999,
  })

  TransactionModals.value.push({
    title: 'Txn for Setting up SamuhikaToken Vault',
    transactionId: transaction,
  })

  await fcl.tx(transaction).onceSealed()

  isChecking.value = true
  await getBalance()
}

async function mintToken() {
  if (!userData.value?.addr)
    return router.push('/')

  await pledgeTokens()

  navigateTo('/home')
  isChecking.value = true
  await getBalance()
}

onMounted(async () => {
  await getBalance()
})
</script>

<template>
  <div h-full w-full>
    <div v-if="isChecking" h-full w-full flex flex-col items-center justify-center gap-4>
      <div h-12 w-12 i-eos-icons-bubble-loading />
      <span text-lg>Checking Flow account compatibility...</span>
    </div>

    <div v-if="!isChecking && !balance" h-full w-full flex flex-col items-center justify-center gap-4>
      <div h-12 w-12 i-ic-baseline-block text-red />
      <span text-lg>
        To be a part of the Sarpanch DAO, you need to have some <span text-lime>Samuhika Token</span>. Based on your wallet and history, it seems like you are new.
      </span>
      <span>Let's setup your account.</span>

      <button px-12 py-4 mt-4 rounded-md border-2 hover:bg-white hover:text-black class="group" @click="setupAccount()">
        Setup your flow wallet for <span text-lime group-hover:text-lime-800>Samuhika Token</span>
      </button>
    </div>

    <div v-if="!isChecking && balance <= 0" h-full w-full flex flex-col items-center justify-center gap-4>
      <span>
        Congratulations! You have <span text-lime>Samuhika Token</span> linked to your FLOW wallet, but you do not have any balance left.
      </span>
      <span>
        You need to <span text-red>Pledge</span> $FLOW tokens to be a part of SarpanchDAO. You will receive <span text-lime>Samuhika Token</span> after pledging which can be used for multiple in DAO activities.
      </span>
      <span>
        Please use the button below Pledge $FLOW and mint some <span text-lime>Samuhika Token</span> for yourself.
      </span>

      <button flex items-center gap-4 px-12 py-4 mt-4 rounded-md border-2 hover:bg-white hover:text-black class="group" @click="mintToken()">
        <div i-ph-plant />
        <span>Pledge 1000 $FLOW & Mint <span text-lime group-hover:text-lime-800>Samuhika Token</span></span>
      </button>
    </div>

    <div v-if="!isChecking" h-full w-full flex flex-col items-center justify-center gap-4>
      <span>
        Congratulations! You have <span text-lime>Samuhika Token</span> linked to your FLOW wallet.
      </span>

      <NuxtLink to="/home" mt-2 px-12 py-2 border-2 rounded-md flex items-center gap-2 hover:border-4>
        <span>Continue to Sarpanch</span>
        <div i-material-symbols-arrow-right-alt />
      </NuxtLink>
    </div>
  </div>
</template>

<style scoped>

</style>
