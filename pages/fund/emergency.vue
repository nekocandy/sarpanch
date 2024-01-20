<script setup lang="ts">
import * as fcl from '@onflow/fcl'
import getTreasuryInfo from '~/utils/flow/treasury'
import DepositToTreasury from '~/cadence/transactions/depositTokensToTreasury.cdc?raw'
import flowData from '~/flow.json'

const treasuryData = await getTreasuryInfo()

async function onDonateClicked() {
  // eslint-disable-next-line no-alert
  const amount = prompt('How much would you like to donate?')
  if (!amount)
    return

  const transaction = await fcl.mutate({
    cadence: DepositToTreasury,
    // @ts-expect-error no typings for fcl
    args: (arg, t) => [
      // TODO: get the address of the current user
      arg(`0x${flowData.accounts.default.address}`, t.Address),
      arg(Number.parseFloat(amount).toFixed(2), t.UFix64),
      arg('Donation to Emergency Fund!', t.String),
    ],
    // @ts-expect-error no typings for fcl
    proposer: fcl.authz,
    // @ts-expect-error no typings for fcl
    payer: fcl.authz,
    // @ts-expect-error no typings for fcl
    authorizations: [fcl.authz],
    limit: 999,
  })

  consola.info('transaction', transaction)
  await fcl.tx(transaction).onceSealed()
}
</script>

<template>
  <div h-full w-full flex flex-col items-center justify-center gap-4>
    <div gap-4 border-4 rounded-md px-24 py-24 flex flex-col items-center justify-between>
      <div class="text-4xl font-bold">
        Emergency Fund
      </div>
      <div />
      <div class="text-2xl" text-lime>
        {{ treasuryData.balance }} $FLOW
      </div>
    </div>
    <span text-sm>*Can only be withdrawn after a majority vote of SarpanchDAO Stakeholders</span>
    <div mt-4>
      <button text-2xl bg-lime rounded-md border-2 px-24 py-4 text-black @click="onDonateClicked()">
        Donate
      </button>
    </div>
  </div>
</template>

<style scoped>

</style>
