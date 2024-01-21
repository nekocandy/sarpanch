<script setup lang="ts">
import * as fcl from '@onflow/fcl'
import CREATE_PROPOSAL from '~/cadence/transactions/createVotingProposal.cdc?raw'

const proposalName = ref('')
const proposalDescription = ref('')
const proposalStartTime = ref(dayjs().unix().toFixed(1))
const proposalEndTime = ref(dayjs().add(1, 'day').unix().toFixed(1))

async function Propose() {
  if (!proposalName.value || !proposalDescription.value) {
    // eslint-disable-next-line no-alert
    alert('Please fill in all fields')
    return
  }

  consola.info('Proposing', proposalName.value, proposalDescription.value, proposalStartTime.value, proposalEndTime.value)
  const transaction = await fcl.mutate({
    cadence: CREATE_PROPOSAL,
    // @ts-expect-error no typings
    args: (arg, t) => [
      arg(proposalName.value, t.String),
      arg(proposalDescription.value, t.String),
      arg(proposalStartTime.value, t.UFix64),
      arg(proposalEndTime.value, t.UFix64),
    ],
    // @ts-expect-error no typings
    proposer: fcl.authz,
    // @ts-expect-error no typings
    payer: fcl.authz,
    // @ts-expect-error no typings
    authorizations: [fcl.authz],
    limit: 9999,
  })

  consola.info('Proposed', transaction)
  TransactionModals.value.push({
    title: 'Txn for New voting proposal',
    transactionId: transaction,
  })
}
</script>

<template>
  <div flex flex-col gap-8>
    <h1>Create A Proposal (Sarpanch/Admin Only)</h1>
    <div flex items-center gap-8 w-full h-full>
      <div w-full>
        <label for="proposalName">Proposal Name: </label>
        <input id="proposalName" v-model="proposalName" px-2 py-1 bg-zinc-800 focus:outline-none border-1 rounded-md w-full>
      </div>

      <div w-full>
        <label for="proposalDescription">Proposal Description: </label>
        <textarea id="proposalDescription" v-model="proposalDescription" px-2 py-1 bg-zinc-800 focus:outline-none border-1 rounded-md w-full />
      </div>

      <div h-full self-center>
        <button h-full px-12 py-2 bg-lime text-black @click="Propose">
          Propose
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
