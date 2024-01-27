<script setup lang="ts">
import { appKeywords, appName } from "@/constants/index";
import { WsMsgBodyType, WsStatusEnum } from "~/composables/types/WsType";

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
    else {
      navigateTo("/login");
    }
  },
  {
    immediate: true,
  },
);


const ws = useWs();
const timer = ref();


// 通知消息类型  WsMsgBodyType
const noticeType = [
  WsMsgBodyType.MESSAGE, // 普通消息
];

watch(() => user.getToken, (val) => {
  if (val)
    load();
  else
    ws.webSocketHandler?.close();
}, {
  immediate: true,
  deep: true,
});

const route = useRoute();
onUnmounted(() => {
  if (!route.path.startsWith("/chat")) {
    clearInterval(timer.value);
    if (ws.webSocketHandler)
      ws.webSocketHandler?.close();
    timer.value = false;
  }
});
// 初始化
function load() {
  ws.initDefault((e) => {
    timer.value = setInterval(() => {
      if (ws.status === WsStatusEnum.CLOSE) {
        clearInterval(timer.value);
        timer.value = null;
        load();
      }
      else {
        // 心跳
        ws.sendHeart();
      }
    }, 10000);
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
  filter: blur(20px) contrast(4);
}
</style>
