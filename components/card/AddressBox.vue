<script lang="ts" setup>
import type { AddressInfoVO } from "~/composables/api/user/address";

const { address } = defineProps<{
  address: AddressInfoVO
}>();
</script>

<template>
  <div
    :key="address.id"
    hover:border="solid [var(--el-color-primary)]"
    hover:shadow="lg var(--el-color-primary)"
    class="group"
    relative flex flex-col cursor-pointer border-2px rounded-6px rounded-8px p-2 leading-1.2em opacity-90 shadow-sm transition-300 border-default md:p-4 dark:hover:border-gray-5
  >
    <div
      w-full flex-row-c-c justify-start border-0 border-b-2px pb-2 font-600 border-default-dashed
    >
      <p>{{ address.name }}</p>
      <el-tag
        v-if="address.isDefault && address.isDefault === 1"
        class="absolute right-3"
        plain
      >
        <span flex>
          默认
          <span
            hidden
            md:block
          >
            地址
          </span>
        </span>
      </el-tag>
    </div>
    <small pt-2>{{ address.phone }}</small>
    <div

      mt-1 opacity-80
    >
      <small pr-1>{{ address.province }}</small>
      <small pr-1>{{ address.city }}</small>
      <small pr-1>{{ address.county }}</small>
    </div>
    <small class="truncate">{{ address.address }}</small>
    <small>邮编:{{ address.postalCode }}</small>
    <div class="btns mt-a w-1/1 flex-row-bt-c">
      <slot name="btns" />
    </div>
  </div>
</template>

<style scoped lang="scss"></style>
