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
      loadWs();
    }
    else {
      navigateTo("/login");
      ws.webSocketHandler?.close(); // 关闭ws
    }
  },
  {
    immediate: true,
  },
);

const timer = ref();
// 通知消息类型  WsMsgBodyType
const noticeType = [
  WsMsgBodyType.MESSAGE, // 普通消息
];
// 初始化
function loadWs() {
  ws.initDefault((e) => {
    timer.value = setInterval(() => {
      if (ws.status === WsStatusEnum.CLOSE) {
        clearInterval(timer.value);
        timer.value = null;
        loadWs();
      }
      else {
        // 心跳
        ws.sendHeart();
      }
    }, 20000);
    ws.onMessage((msg) => {
      // 消息通知
      if (ws.isWindBlur && noticeType.includes(msg.type)) {
        const body = msg.data as ChatMessageVO;
        useWebToast(
          `${body.fromUser.nickName}:`, // 发送人
        `${body.message.content}`, // 发送消息
        {
          icon: BaseUrlImg + body.fromUser.avatar,
        });
      }
    });
  });
}
// TODO: 单次运行是否失去焦点
onMounted(() => {
  if (!document)
    return;
  let hiddenProp: any, visibilityChange;
  if (typeof document?.hidden !== "undefined") {
    hiddenProp = "hidden";
    visibilityChange = "visibilitychange";
  }
  // @ts-expect-error
  else if (typeof document?.mozHidden !== "undefined") {
    hiddenProp = "mozHidden";
    visibilityChange = "mozvisibilitychange";
  }
  // @ts-expect-error
  else if (typeof document?.msHidden !== "undefined") {
    hiddenProp = "msHidden";
    visibilityChange = "msvisibilitychange";
  }
  // @ts-expect-error
  else if (typeof document?.webkitHidden !== "undefined") {
    hiddenProp = "webkitHidden";
    visibilityChange = "webkitvisibilitychange";
  }

  // 添加监听器
  // @ts-expect-error
  document?.addEventListener(visibilityChange, () => {
    // @ts-expect-error
    if (!document[hiddenProp])
      ws.isWindBlur = false;
    else
      ws.isWindBlur = true;
  }, false);
});
const route = useRoute();
onUnmounted(() => {
  if (route.path.startsWith("/login")) {
    clearInterval(timer.value);
    if (ws.webSocketHandler)
      ws.webSocketHandler?.close();
    timer.value = false;
  }
});


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
  <div id="app" card-default bg-color>
    <OtherLoading />
    <NuxtPage />
  </div>
</template>

<style lang="scss">
.page-enter-active,
.page-leave-active {
  opacity: 1;
  transition-duration: 0.3s;
  transition-property: filter, opacity;
  will-change: filter, opacity;
}

.page-enter-from,
.page-leave-to {
  filter: blur(4px) contrast(4);
}

.dark .page-enter-from,
.dark .page-leave-to {
  filter: blur(4px);
}
</style>
