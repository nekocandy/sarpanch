<script setup lang="ts">
import { logOut } from '~/utils/flow/auth'

const router = useRouter()

onMounted(() => {
  if (!userData.value || !userData.value.addr)
    router.push('/')
})

watch(userData, (newData) => {
  consola.log('userData changed', newData)
  if (!newData || !newData.addr)
    router.push('/')
})
</script>

<template>
  <div m-4 p-4 rounded-md bg-orange-900 flex items-center justify-between>
    <div>
      {{ userData?.addr || 'Not logged in' }}
    </div>

    <NuxtLink href="/home" text-xl uppercase>
      Sarpanch
    </NuxtLink>

    <div>
      <button v-if="userData?.addr" border-2 px-8 py-2 rounded-md @click="logOut">
        Logout
      </button>
    </div>
  </div>
</template>

<style scoped>

</style>
