<script setup lang="ts">
import * as fcl from '@onflow/fcl'
import { sendFlow } from '~/utils/flow/utils'
import CREATE_PROJECT from '/cadence/transactions/createProject.cdc?raw'
import GET_PROJECTS from '/cadence/scripts/getCommunityProjects.cdc?raw'
import DONATE_TO_PROJECT from '/cadence/transactions/donateToProject.cdc?raw'

const projects = ref<{
  name: string
  address: string
  description: string
  image: string
}[]>([])
const projectName = ref('')
const projectDescription = ref('')
const projectImage = ref('')
const projectAddress = ref(userData.value?.addr ?? '')
const imageUploading = ref(false)

async function getProjects() {
  const response = await fcl.query({
    cadence: GET_PROJECTS,
    limit: 9999,
  })

  consola.info(response)

  projects.value = response
}

async function createProject() {
  if (!projectName.value || !projectDescription.value || !projectImage.value || !projectAddress.value)
    return consola.error('Please fill out all fields')

  const transaction = await fcl.mutate({
    cadence: CREATE_PROJECT,
    limit: 9999,
    // @ts-expect-error not sure how to type this
    args: (arg, t) => [
      arg(projectName.value, t.String),
      arg(projectDescription.value, t.String),
      arg(projectImage.value, t.String),
      arg(projectAddress.value, t.Address),
    ],
    // @ts-expect-error not sure how to type this
    payer: fcl.authz,
    // @ts-expect-error not sure how to type this
    proposer: fcl.authz,
    // @ts-expect-error not sure how to type this
    authorizations: [fcl.authz],
  })

  TransactionModals.value.push({
    title: 'Txn for Creating Project for Community Fund',
    transactionId: transaction,
  })

  await fcl.tx(transaction).onceSealed()
  consola.info('Project created')
  await getProjects()
}

async function fileUploaded(event: Event) {
  // @ts-expect-error not sure how to type this
  const file = event.target.files[0]

  consola.info(`file ${file}`)
  if (!file)
    return

  imageUploading.value = true

  const data = await uploadImage(file)
  consola.info(data)

  projectImage.value = data
  imageUploading.value = false
}

function generateIPFSImageURL(cid: string) {
  return `https://${cid}.ipfs.dweb.link/`
}

async function fundProject(projectAddress: string, projectName: string, index: number) {
  // eslint-disable-next-line no-alert
  const amount = prompt(`How much would you like to fund ${projectName}?`)
  if (!amount)
    return

  const fundingTransactionId = await sendFlow(projectAddress, amount)

  TransactionModals.value.push({
    title: `Txn for Funding ${projectName}`,
    transactionId: fundingTransactionId,
  })

  await fcl.tx(fundingTransactionId).onceSealed()
  consola.info('Funding complete')

  const donationStorageTxnId = await fcl.mutate({
    cadence: DONATE_TO_PROJECT,
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
    title: `Txn for Storing Donation for ${projectName}`,
    transactionId: donationStorageTxnId,
  })

  await fcl.tx(donationStorageTxnId).onceSealed()
  consola.info('Donation stored')

  await getProjects()
}

onMounted(async () => {
  await getProjects()
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
          <label for="projectName">Project Name</label>
          <input id="projectName" v-model="projectName" px-2 py-1 bg-zinc-800 focus:outline-none border-1 rounded-md w-full>
        </div>

        <div flex items-center gap-4 w-full>
          <label for="projectDescription">Project Description</label>
          <textarea id="projectDescription" v-model="projectDescription" px-2 py-1 bg-zinc-800 focus:outline-none border-1 rounded-md w-full />
        </div>

        <div flex items-center gap-4 w-full>
          <label for="projectAddress">Funding Address</label>
          <input id="projectAddress" v-model="projectAddress" px-2 py-1 bg-zinc-800 focus:outline-none border-1 rounded-md w-full>
        </div>

        <div flex items-center gap-4 w-full>
          <div
            :class="{
              'i-line-md-uploading-loop h-8 w-8': imageUploading,
              'i-line-md-check-all h-8 w-8': !imageUploading && projectImage,
            }"
          />
          <label for="projectImage">Project Image</label>
          <input id="projectImage" px-2 py-1 bg-zinc-800 focus:outline-none border-1 rounded-md w-full type="file" accept="image/png" @change="fileUploaded">
        </div>

        <button bg-lime px-12 w-fit py-2 rounded-md text-black border-2 @click="createProject()">
          Create Project
        </button>
      </div>
    </div>

    <div flex-1 flex>
      <div grid grid-cols-4 gap-8 w-full>
        <div v-for="(project, index) in projects" :key="project.image" h-fit w-full rounded-md px-4 py-4 flex flex-col items-center justify-between border-2 gap-4>
          <img mx-auto h-40 :src="generateIPFSImageURL(project.image)" alt="project_image_from_ipfs">

          <div>
            <h2 text-xl font-black>
              {{ project.name }}
            </h2>

            <p>
              {{ project.description }}
            </p>
          </div>

          <div flex items-center>
            <button bg-lime px-12 w-fit py-2 rounded-md text-black border-2 @click="fundProject(project.address, project.name, index)">
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
