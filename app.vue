<script setup lang="ts">
import { appKeywords, appName } from "@/constants/index";
import { WsMsgBodyType, WsStatusEnum } from "~/composables/types/WsType";

const user = useUserStore();
const setting = useSettingStore();
const colorMode = useColorMode();
const ws = useWs();
// 退出登录时候
watch(
  () => user.isLogin,
  async (val) => {
    if (val) {
      // 获取用户信息
      user.onCheckLogin();
    }
    else {
      navigateTo("/login");
    }
  },
  {
    immediate: true,
  },
);
// 同步修改系统
watch(() => setting.settingPage.modeToggle.value, (val) => {
  // @ts-expect-error
  window?.darkMode.toggle(val);
  useModeToggle(val);
}, {
  immediate: true,
});


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


function keyToggleTheme(e: KeyboardEvent) {
  if (setting.isThemeChangeLoad)
    return;
  if (e?.altKey && e?.key && e?.key === "k")
    useModeToggle(colorMode.preference === "dark" ? "light" : "dark");
}
onMounted(() => {
  setting.isThemeChangeLoad = false;
  // 主题快捷键
  window.addEventListener("keydown", keyToggleTheme);
});

onUnmounted(() => {
  window.removeEventListener("keydown", keyToggleTheme);
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
</script>

<template>
  <div id="app">
    <OtherLoading />
    <NuxtPage />
  </div>
</template>

<style lang="scss">
main {
}
</style>
