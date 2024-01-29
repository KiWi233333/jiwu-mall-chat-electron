<script lang="ts" setup>
defineProps({
  menu: {
    default: ["back", "home", "aichat"],
    required: false,
  },
});
</script>

<template>
  <main>
    <ChatLayout max-h-100vh max-w-100vw>
      <slot />
    </ChatLayout>
  </main>
</template>

<style  lang="scss" scoped>
main {
  width: 100%;
}
</style>
