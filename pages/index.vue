<script setup lang="ts">
import FlowLogo from '~/assets/flow.svg'
import { logIn } from '~/utils/flow/auth'
import { userData } from '~/utils/store'

const router = useRouter()

async function handleAuth() {
  consola.info('userData', userData.value?.addr)

  if (userData.value?.addr)
    router.push('/dashboard')

  else
    logIn()
}
</script>

<template>
  <div h-full w-full flex flex-col items-center justify-center gap-4>
    <div text-orange font-hindi text-6xl>
      सरपंच
    </div>
    <div text-8xl uppercase>
      Sarpanch
    </div>

    <div>
      <button bg-orange px-12 py-4 text-green-900 text-2xl mt-12 font-bold uppercase @click="handleAuth">
        <div v-if="userData && userData.addr" flex items-center justify-center gap-2>
          Continue {{ userData.addr }} <div i-fluent-arrow-next-12-filled />
        </div>
        <div v-else flex items-center justify-center gap-4>
          Login with
          <img h-8 :src="FlowLogo" alt="flow">
        </div>
      </button>
    </div>
  </div>
</template>

<style scoped>

</style>
