<script lang="ts" setup>
import { Notifications, Notivue } from 'notivue'
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
