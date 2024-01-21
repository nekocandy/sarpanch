<script setup lang="ts">
import * as fcl from '@onflow/fcl'
import CREATE_PROJECT from '/cadence/transactions/createProject.cdc?raw'

const projectName = ref('')
const projectDescription = ref('')
const projectImage = ref('')
const imageUploading = ref(false)

async function _createProject() {
  if (!projectName.value || !projectDescription.value || !projectImage.value)
    return

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
      <div flex items-center justify-between>
        <div flex items-center gap-4>
          <label for="projectName">Project Name</label>
          <input id="projectName" v-model="projectName">
        </div>

        <div flex items-center gap-4>
          <label for="projectDescription">Project Description</label>
          <input id="projectDescription" v-model="projectDescription">
        </div>

        <div flex items-center gap-4>
          <div
            :class="{
              'i-line-md-uploading-loop': imageUploading,
              'i-line-md-check-all': !imageUploading && projectImage,
            }"
          />
          <label for="projectImage">Project Image</label>
          <input id="projectImage" type="file" accept="image/png" @change="fileUploaded">
        </div>

        <button @click="_createProject()">
          Create Project
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
