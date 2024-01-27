<script setup lang="ts">
import { appKeywords, appName } from "@/constants/index";

// 1、确认是否登录
const user = useUserStore();
// 退出登录时候
watch(
  () => user.isLogin,
  async (val) => {
    if (val) {
      // 获取用户信息
      user.onCheckLogin();
    }
  },
  {
    immediate: true,
  },
);

// https://nuxt.com.cn/docs/guide/directory-structure/app
// 准备完成关闭加载
onMounted(() => {
  const font = localStorage.getItem("--font-family");
  if (font)
    document.documentElement.style.setProperty("--font-family", font);

  const isColseAllTransition = localStorage.getItem("isColseAllTransition");
  // 是否关闭动画
  if (isColseAllTransition && isColseAllTransition === "true")
    document.documentElement.classList.add("stop-transition-all");
  else
    document.documentElement.classList.remove("stop-transition-all");
});
useHead({
  title: `${appName} - 开启你的极物之旅 ✨`,
  meta: [
    {
      name: "description",
      content: "极物圈-主页 开启你的极物之旅！",
    },
  ],
});
useSeoMeta({
  title: `${appName} - 开启你的极物之旅 ✨`,
  description: "极物圈-主页 开启你的极物之旅！",
  keywords: appKeywords,
});


const setting = useSettingStore();
const colorMode = useColorMode();
function keyToggleTheme(e: KeyboardEvent) {
  if (setting.isThemeChangeLoad)
    return;
  if (e?.altKey && e?.key && e?.key === "k") {
    // 计算屏幕中心坐标
    const centerX = (window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth) / 2;
    const centerY = (window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight) / 2;
    useModeToggle(colorMode.preference === "dark" ? "light" : "dark", {
      clientX: +centerX,
      clientY: +centerY,
    } as MouseEvent);
  }
}
onMounted(() => {
  setting.isThemeChangeLoad = false;
  // 覆盖
  window.addEventListener("keydown", keyToggleTheme);
});

onUnmounted(() => {
  window.removeEventListener("keydown", keyToggleTheme);
});
</script>

<template>
  <div id="app">
    <!-- Pwa -->
    <VitePwaManifest />
    <OtherLoading />
    <!-- 进度 -->
    <NuxtLoadingIndicator :duration="500" color="linear-gradient(to right, #4bf380, #71e9ed, #f64f59)" />
    <NuxtPage />
    <ClientOnly>
      <FormUserDialog v-if="!user.isLogin" />
    </ClientOnly>
  </div>
</template>

<style lang="scss">
// .layout-enter-active,
// .layout-leave-active,
.page-enter-active,
.page-leave-active {
  opacity: 1;
  transition-duration: 0.3s;
  transition-property: filter, opacity;
  will-change: filter, opacity;
}

.page-enter-from,
.page-leave-to {
  opacity: 0;
  filter: blur(4px) contrast(4);
}

.dark .page-enter-from,
.dark .page-leave-to {
  opacity: 0.7;
  filter: none;
}
</style>
