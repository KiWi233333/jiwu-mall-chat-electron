<script lang="ts" setup>
defineProps<{
  src: string
}>();
const status = ref("loading");
</script>

<template>
  <ClientOnly>
    <template #fallback>
      <OtherPreLoading
        message=""
        icon=""
        v-bind="$attrs"
      />
    </template>
    <el-image
      v-bind="$attrs"
      :src="src"
      fit="cover"
    >
      <!-- 占位 -->
      <template #placeholder>
        <div class="h-full w-full flex-row-c-c">
          <i class="icon" i-solar:menu-dots-bold-duotone opacity-40 />
        </div>
      </template>
      <!-- 错误 -->
      <template #error>
        <div class="h-full w-full flex-row-c-c">
          <i class="icon" i-solar:cup-hot-line-duotone opacity-50 />
        </div>
      </template>
    </el-image>
  </ClientOnly>
</template>

<style scoped lang="scss">
.icon {
  -at-apply: "block max-w-2/3 min-h-1rem min-w-1rem"
}
</style>
