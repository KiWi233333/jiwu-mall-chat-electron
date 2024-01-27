<script lang="ts" setup>
</script>

<template>
  <!-- 菜单栏 -->
  <menu class="nav h-2rem" style="-webkit-app-region: drag;">
    <div class="left" />
    <div class="right" />
  </menu>
</template>

<style lang="scss" scoped>
.nav {
  box-shadow: rgba(9, 30, 66, 0.1) 0px 4px 2px -2px;
  position: sticky;
  top: 0;
  z-index: 999;
  height: $top-nav-height;
  background-size: 3px 3px;
  backdrop-filter: saturate(50%) blur(1rem);
  background-image: radial-gradient(transparent 1px, var(--el-bg-color) 1px);
}

.dark .nav {
  background-image: radial-gradient(transparent 1px, var(--el-bg-color) 1px);
  background-size: 3px 3px;
  box-shadow: rgba(92, 97, 124, 0.02) 12px 12px 60px;
}
</style>
