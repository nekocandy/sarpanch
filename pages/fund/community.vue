<script setup lang="ts">
import * as fcl from '@onflow/fcl'
import CREATE_PROJECT from '/cadence/transactions/createProject.cdc?raw'

const projectName = ref('')
const projectDescription = ref('')
const projectImage = ref('')

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
</script>

<template>
  <div h-full w-full flex flex-col gap-4>
    <div flex items-center justify-between>
      <h1 text-xl font-black>
        Fund Community Projects
      </h1>
    </div>

    <div />
  </div>
</template>

<style scoped>

</style>
