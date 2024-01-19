<script setup lang="ts">
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

    <NuxtLink href="/dashboard" text-xl uppercase>
      Sarpanch
    </NuxtLink>

    <div />
  </div>
</template>

<style scoped>

</style>
