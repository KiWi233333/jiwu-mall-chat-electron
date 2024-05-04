<script lang="ts" setup>
import { appKeywords } from "@/constants/index";

useSeoMeta({
  title: "极物圈登录",
  description: "极物 - 聊天 - 极物圈 开启你的极物之旅！",
  keywords: appKeywords,
});
const user = useUserStore();
definePageMeta({
  key: route => route.fullPath,
  layout: false,
});
onMounted(() => {
  user.showLoginForm = true;
});
</script>

<template>
  <Transition
    name="popup"
    mode="in-out"
  >
    <!-- 登录 -->
    <FormLoginForm
      v-if="user.showLoginForm"
      key="login-form" class="form"
    />
    <!-- 注册 -->
    <FormRegisterForm
      v-else-if="user.showRegisterForm"
      key="register-form" class="form"
    />
  </Transition>
</template>

<style scoped lang="scss">
.form {
  --at-apply: "relative mx-a w-420px rounded-6px bg-white shadow-2xl border-default dark:bg-dark-7"
}
</style>
