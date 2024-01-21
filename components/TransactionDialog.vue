<script setup lang="ts">
import * as fcl from '@onflow/fcl'
import { DialogContent, DialogOverlay, DialogPortal, DialogRoot, DialogTitle } from 'radix-vue'
import FlowImage from '~/assets/flow.svg'

const props = defineProps<{
  title: string
  transactionId: string
  open?: boolean
}>()

const isOpen = toRef<boolean>(props.open || true)
const transactionStatus = ref<number>(-1)
const transactionStatusText = computed(() => {
  switch (transactionStatus.value) {
    case 0:
      return 'APPROVAL'
    case 1:
      return 'PENDING'
    case 2:
      return 'FINALIZED'
    case 3:
      return 'EXECUTED'
    case 4:
      return 'SEALED'
    default:
      return 'UNKNOWN'
  }
})

onMounted(async () => {
  consola.info('TransactionDialog', props.transactionId)
  fcl.tx(props.transactionId).subscribe((transaction) => {
    transactionStatus.value = transaction.status
  })
})
</script>

<template>
  <DialogRoot
    :open="isOpen"
    @close="() => isOpen = false"
  >
    <DialogPortal>
      <DialogOverlay class="bg-zinc/70 data-[state=open]:animate-overlayShow fixed inset-0 z-30" />

      <DialogContent
        class="fixed top-[50%] left-[50%] max-h-[85vh] w-[90vw] max-w-[450px] translate-x-[-50%] translate-y-[-50%] rounded-[6px] bg-white p-[25px] shadow-[hsl(206_22%_7%_/_35%)_0px_10px_38px_-10px,_hsl(206_22%_7%_/_20%)_0px_10px_20px_-15px] focus:outline-none z-[100]"
      >
        <DialogTitle class="font-mono text-sm font-semibold">
          {{ $props.title }}
        </DialogTitle>

        <div pt-8 pb-2 flex flex-col items-center justify-center gap-4>
          <div
            h-12 w-12 :class="{
              'i-carbon-checkmark-outline bg-green-600': transactionStatus === 4,
              'i-ic-baseline-help-outline bg-red-600': transactionStatus <= 0,
              'i-line-md-loading-twotone-loop bg-yellow-900': transactionStatus > 0 && transactionStatus < 4,
            }"
          />

          <div class="font-bold" text-xs text-ellipsis text-center flex flex-col>
            Current Transaction Status
            <span text-lime-900>{{ transactionStatusText }}</span>
          </div>

          <div class="font-bold" text-xs text-ellipsis text-center flex flex-col>
            Transaction ID
            <span text-lime-900>{{ $props.transactionId }}</span>
          </div>

          <NuxtLink :to="`https://testnet.flowdiver.io/tx/${props.transactionId}`" target="_blank" text-blue-900 flex items-center gap-1 border-2 border-blue-900 px-8 py-2 hover:bg-blue-900 hover:text-white rounded-md>
            <span>View on FlowDiver</span>
            <div i-material-symbols-open-in-new />
          </NuxtLink>

          <div w-full flex items-center justify-between>
            <img :src="FlowImage" alt="Flow" class="w-24 h-24 -my-18">

            <button
              px-8
              py-1 border-2 border-black rounded-md hover:bg-zinc-900 hover:text-white @click="isOpen = false"
            >
              Close
            </button>
          </div>
        </div>
      </DialogContent>
    </DialogPortal>
  </DialogRoot>
</template>

<style scoped>

</style>
