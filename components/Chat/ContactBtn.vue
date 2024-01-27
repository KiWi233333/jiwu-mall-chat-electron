<script lang="ts" setup>
const setting = useSettingStore();
</script>

<template>
  <span
    class="ml-a mt-6 p-1 transition-300 btn-primary hover:scale-120"
    @click="setting.isOpenContact = !setting.isOpenContact"
  >
    <i class="i-solar:chat-square-bold-duotone" cursor-pointer p-0.6em />
  </span>
</template>

<style lang="scss" scoped>
</style>
