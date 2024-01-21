<script setup lang="ts">
import * as fcl from '@onflow/fcl'
import { sendFlow } from '~/utils/flow/utils'
import CREATE_SCHOLARSHIP_REQUEST from '~/cadence/transactions/createScholarshipRequest.cdc?raw'
import GET_SCHOLARSHIP_REQUESTS from '~/cadence/scripts/getScholarshipRequests.cdc?raw'
import FUND_SCHOLARSHIP from '~/cadence/transactions/fundScholarship.cdc?raw'

const requests = ref<{
  name: string
  address: string
  description: string
}[]>([])

const requestUserName = ref('')
const requestUserWhy = ref('')
const requesterAddress = ref(userData.value?.addr ?? '')

async function getRequests() {
  const response = await fcl.query({
    cadence: GET_SCHOLARSHIP_REQUESTS,
    limit: 9999,
  })

  consola.info(response)

  requests.value = response
}

async function createFundingRequest() {
  if (!requestUserName.value || !requestUserWhy.value || !requesterAddress.value)
    return consola.error('Please fill out all fields')

  const transaction = await fcl.mutate({
    cadence: CREATE_SCHOLARSHIP_REQUEST,
    limit: 9999,
    // @ts-expect-error not sure how to type this
    args: (arg, t) => [
      arg(requestUserName.value, t.String),
      arg(requestUserWhy.value, t.String),
      arg(requesterAddress.value, t.Address),
    ],
    // @ts-expect-error not sure how to type this
    payer: fcl.authz,
    // @ts-expect-error not sure how to type this
    proposer: fcl.authz,
    // @ts-expect-error not sure how to type this
    authorizations: [fcl.authz],
  })

  TransactionModals.value.push({
    title: 'Txn for Creating Scholarship Request',
    transactionId: transaction,
  })

  await fcl.tx(transaction).onceSealed()
  consola.info('Scholarship Request created')
  await getRequests()
}

async function fundRequest(address: string, name: string, index: number) {
  // eslint-disable-next-line no-alert
  const amount = prompt(`How much would you like to fund for ${name}'s scholarship?`)
  if (!amount)
    return

  const fundingTransactionId = await sendFlow(address, amount)

  TransactionModals.value.push({
    title: `Txn for Funding of ${name}'s scholarship`,
    transactionId: fundingTransactionId,
  })

  await fcl.tx(fundingTransactionId).onceSealed()

  const donationTxnId = await fcl.mutate({
    cadence: FUND_SCHOLARSHIP,
    limit: 9999,
    // @ts-expect-error not sure how to type this
    args: (arg, t) => [
      arg(index, t.Int),
      arg(Number.parseFloat(amount).toFixed(2), t.UFix64),
      arg(fundingTransactionId, t.String),
    ],
    // @ts-expect-error not sure how to type this
    payer: fcl.authz,
    // @ts-expect-error not sure how to type this
    proposer: fcl.authz,
    // @ts-expect-error not sure how to type this
    authorizations: [fcl.authz],
  })

  TransactionModals.value.push({
    title: `Txn for Storing Scholarship Donation for ${name}`,
    transactionId: donationTxnId,
  })

  await fcl.tx(donationTxnId).onceSealed()
  consola.info('Donation stored')

  await getRequests()
}

onMounted(async () => {
  await getRequests()
})
</script>

<template>
  <div h-full w-full flex flex-col gap-4>
    <div flex items-center justify-between>
      <h1 text-xl font-black>
        Fund Community Projects
      </h1>
    </div>

    <div flex flex-col gap-4>
      <div flex items-center justify-between gap-12>
        <div flex items-center gap-4 w-full>
          <label for="requestUserName">Your Name</label>
          <input id="requestUserName" v-model="requestUserName" px-2 py-1 bg-zinc-800 focus:outline-none border-1 rounded-md w-full>
        </div>

        <div flex items-center gap-4 w-full>
          <label for="requestUserWhy">Why should we donate funds to you?</label>
          <textarea id="requestUserWhy" v-model="requestUserWhy" px-2 py-1 bg-zinc-800 focus:outline-none border-1 rounded-md w-full />
        </div>

        <div flex items-center gap-4 w-full>
          <label for="requesterAddress">Requester Address</label>
          <input id="requesterAddress" v-model="requesterAddress" px-2 py-1 bg-zinc-800 focus:outline-none border-1 rounded-md w-full>
        </div>
      </div>

      <button bg-lime px-12 w-fit py-2 rounded-md text-black border-2 @click="createFundingRequest()">
        Create Request
      </button>
    </div>

    <div flex-1 flex>
      <div grid grid-cols-4 gap-8 w-full>
        <div v-for="(request, index) in requests" :key="request.description" h-fit w-full rounded-md px-4 py-4 flex flex-col items-center justify-between border-2 gap-4>
          <div>
            <h2 text-xl font-black>
              {{ request.name }}
            </h2>

            <p>
              {{ request.description }}
            </p>
          </div>

          <div flex items-center>
            <button bg-lime px-12 w-fit py-2 rounded-md text-black border-2 @click="fundRequest(request.address, request.name, index)">
              Fund
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
