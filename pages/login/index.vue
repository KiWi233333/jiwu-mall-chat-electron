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
</script>

<template>
  <div h-100vh w-100vw flex-row-c-c border-default card-default>
    <NuxtLayout name="default">
      <div>
        <div
          v-auto-animate
          tag="div"
          name="popup"
          class="forms"
          relative
        >
          <!-- 登录 -->
          <FormLoginForm v-if="user.showLoginForm" key="login-form" />
          <!-- 注册 -->
          <FormRegisterForm v-else-if="user.showRegisterForm" key="register-form" />
        </div>
      </div>
    </NuxtLayout>
  </div>
</template>

<style scoped lang="scss">
.forms {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 1002;
  background-color: rgba(70, 70, 70, 0.3);
  backdrop-filter: blur(4px);
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.dark .forms {
  background-color: rgba(20, 20, 20, 0.4);
}
.fadeInOutShadow-enter-active {
  animation: 0.2s fadeIn $animate-cubic;
}

.fadeInOutShadow-leave-active {
  animation: 0.2s fadeOut $animate-cubic;
}

.animate__animated {
  animation-duration: 0.2s;
}
</style>
