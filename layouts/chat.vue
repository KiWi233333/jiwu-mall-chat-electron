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
    <ChatLayout>
      <slot />
    </ChatLayout>
  </main>
</template>

<style  lang="scss" scoped>
main {
  width: 100%;
}
</style>
