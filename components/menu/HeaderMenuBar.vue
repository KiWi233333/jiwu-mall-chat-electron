<script lang="ts" setup>
</script>

<template>
  <!-- 菜单栏 -->
  <menu class="nav h-2rem flex-row-bt-c select-none gap-3 border-0 border-b-1px px-4 shadow-sm border-default">
    <NuxtLink to="/" class="left flex-row-c-c gap-2 tracking-0.2em">
      <CardElImage src="./logo.png" class="h-1.6rem w-1.6rem" />
      <span>极物圈</span>
    </NuxtLink>
    <!-- 拖拽区域 -->
    <div style="-webkit-app-region: drag;flex: 1;height: 100%;" />
    <div class="right" />
  </menu>
</template>

<style lang="scss" scoped>
.nav {
  box-shadow: rgba(9, 30, 66, 0.1) 0px 4px 2px -2px;
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
