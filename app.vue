<script lang="ts" setup>
import { Notifications, Notivue } from 'notivue'
</script>

<template>
  <NuxtLayout>
    <NuxtPage />

    <ClientOnly>
      <Notivue v-slot="item">
        <Notifications :item="item" />
      </Notivue>
    </ClientOnly>
  </NuxtLayout>
</template>
