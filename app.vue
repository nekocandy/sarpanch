<script lang="ts" setup>
import { Notifications, Notivue } from 'notivue'

function checkIFrame() {
  consola.info('checkIFrame')
  const iframe = document.getElementById('FCL_IFRAME')
  if (iframe && iframe.style.zIndex !== '300') {
    consola.info('iframe', iframe.style.zIndex)
    iframe.style.zIndex = '300'
  }
}

onMounted(() => {
  setInterval(checkIFrame, 1000)
})
</script>

<template>
  <NuxtLayout>
    <NuxtPage />

    <TransactionDialog
      v-for="transaction in TransactionModals"
      :key="transaction.transactionId"
      :title="transaction.title"
      :transaction-id="transaction.transactionId"
    />

    <ClientOnly>
      <Notivue v-slot="item">
        <Notifications :item="item" />
      </Notivue>
    </ClientOnly>
  </NuxtLayout>
</template>
