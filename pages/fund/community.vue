<script setup lang="ts">
import * as fcl from '@onflow/fcl'
import CREATE_PROJECT from '/cadence/transactions/createProject.cdc?raw'

const projectName = ref('')
const projectDescription = ref('')
const projectImage = ref('')
const imageUploading = ref(false)

async function createProject() {
  if (!projectName.value || !projectDescription.value || !projectImage.value)
    return consola.error('Please fill out all fields')

  const transaction = await fcl.mutate({
    cadence: CREATE_PROJECT,
    limit: 9999,
    // @ts-expect-error not sure how to type this
    args: (arg, t) => [
      arg(projectName.value, t.String),
      arg(projectDescription.value, t.String),
      arg(projectImage.value, t.String),
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
          <div
            :class="{
              'i-line-md-uploading-loop': imageUploading,
              'i-line-md-check-all': !imageUploading && projectImage,
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
  </div>
</template>

<style scoped>

</style>
