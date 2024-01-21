<script setup lang="ts">
import { hex } from '@vid3v/random-color'

const NAVIGATION = [
  {
    name: 'Fund Community Projects',
    path: '/fund/community',
  },
  {
    name: 'Decentralized Local Community Marketplace',
    path: '/decentralized-community-marketplace',
  },
  {
    name: 'Emergency Fund',
    path: '/fund/emergency',
  },
  {
    name: 'DAO - Inclusive Decision Making',
    path: '/dao',
  },
].map(index => ({
  ...index,
  color: hex(),
}))
</script>

<template>
  <div h-full w-full flex flex-col gap-4>
    <div flex items-center justify-between>
      <h1 text-xl font-black>
        Home
      </h1>
    </div>
    <div flex-1 h-full w-full>
      <div grid grid-cols-4 gap-8>
        <div v-for="item in NAVIGATION" :key="item.path">
          <NuxtLink :to="item.path" flex flex-col items-center justify-center border-2 py-4 px-4 rounded-md h-full>
            <div flex flex-col items-center justify-center gap-4>
              <div
                class="w-24 h-24 rounded-full" :style="{
                  backgroundColor: item.color,
                }"
              />
              <div class="mt-2 text-xl font-bold" text-center>
                {{ item.name }}
              </div>
            </div>
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
