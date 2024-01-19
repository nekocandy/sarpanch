<script setup lang="ts">

</script>

<template>
  <div h-screen bg-zinc-900 font-mono text-white flex flex-col overflow-hidden>
    <div>
      <Navbar />
    </div>

    <div flex-1 h-full w-full overflow-auto px-8>
      <slot />
    </div>

    <div>
      <Footer />
    </div>
  </div>
</template>

<style scoped>

</style>
