<script lang="ts" setup>
import { WsStatusEnum } from "~/composables/types/WsType";

const props = defineProps<{
  roomId?: string
}>();
const chat = useChatStore();
const ws = useWs();
const setting = useSettingStore();

// 获取类型
const getType = computed(() => {
  let msg = "";
  switch (chat?.theContact?.type) {
    case RoomType.GROUP:
      msg = "群";
      break;
    case RoomType.SELFT:
      msg = "私";
      break;
    case RoomType.AICHAT:
      msg = "AI";
      break;
  }
  return msg;
});


const ChatMessageListRef = ref();
const scrollbarRef = ref();

// 发送信息后触发
function onSendMsg(msg: ChatMessageVO) {
  // ChatMessageListRef.value?.appendMsg(msg);
  scrollBottom();
};

const timer = ref<any>(0);
/**
 * 滚动到指定消息
 * @Param msgId 消息id
 * @Param gapCount 偏移消息量（用于翻页）
 */
function scrollReplyMsg(msgId: number, gapCount: number = 0) {
  if (!msgId)
    return;
  const offset = -10;
  const el = document.querySelector(`#chat-msg-${msgId}`) as HTMLElement;
  // 若找不到则进行翻页
  // || !ChatMessageListRef.value?.findMsg(msgId)
  if (!el) {
    timer.value = setTimeout(() => {
      scrollbarRef?.value?.setScrollTop(0);
      scrollReplyMsg(msgId, gapCount);
      if (el) {
        timer.value && clearTimeout(timer.value);
        timer.value = null;
      }
    }, 500);
    return;
  }
  else {
    clearTimeout(timer.value);
    timer.value = null;
  }
  // 找到对应消息
  nextTick(() => {
    if (!el)
      return;
    clearTimeout(timer.value);
    if (scrollbarRef.value?.wrapRef?.scrollTo) {
      scrollbarRef.value?.wrapRef?.scrollTo({
        top: (el?.offsetTop || 0) + offset,
        behavior: "smooth",
      });
    }
    else {
      scrollbarRef.value?.setScrollTop((el?.offsetTop || 0) + offset);
    }

    el.classList.add("reply-shaing");
    timer.value = setTimeout(() => {
      el.classList.remove("reply-shaing");
      timer.value = null;
    }, 3000);
  });
}

const isScroll = ref(false);
// 滚动到底部
function scrollBottom(animate = true) {
  if (isScroll.value)
    return;
  isScroll.value = true;
  timer.value = setTimeout(() => {
    if (animate) {
      scrollbarRef.value?.wrapRef?.scrollTo({
        top: scrollbarRef?.value?.wrapRef?.scrollHeight || 0,
        behavior: "smooth",
      });
    }
    else {
      scrollbarRef.value?.setScrollTop(scrollbarRef?.value?.wrapRef?.scrollHeight || 0);
    }
    isScroll.value = false;
  }, 200);
}

// 保存上一个位置
function saveScrollTop() {
  chat.scrollTopSize = scrollbarRef?.value?.wrapRef?.scrollHeight;
}
function scrollTop(size: number) {
  scrollbarRef.value?.scrollTo({
    top: size || 0,
  });
}
const user = useUserStore();
// 绑定事件
nextTick(() => {
  chat.scrollBottom = scrollBottom;
  chat.scrollReplyMsg = scrollReplyMsg;
  chat.saveScrollTop = saveScrollTop;
  chat.scrollTop = scrollTop;
});

onBeforeUnmount(() => {
  timer.value && clearTimeout(timer.value);
  timer.value = null;
});
</script>

<template>
  <div class="relative flex flex-col">
    <!-- 房间信息 -->
    <h4 class="w-full flex flex-shrink-0 items-center gap-4 border-0 border-b-1 rounded-0 p-4 border-default card-default md:p-4">
      <CardElImage
        :src="BaseUrlImg + chat.theContact.avatar"
        class="h-2.2rem w-2.2rem object-cover border-default card-default"
      />
      <span>
        {{ chat.theContact.name }}
      </span>
      <el-tag effect="dark" size="small">
        {{ getType }}
      </el-tag>
      <!-- 断开会话 -->
      <i
        v-if="ws.status === WsStatusEnum.OPEN"
        circle plain
        class="ml-a cursor-pointer btn-danger"
        transition="all  op-60 group-hover:op-100 300  cubic-bezier(0.61, 0.225, 0.195, 1.3)"
        i-solar:power-bold
        p-2.2 @click="ws.close()"
      />
      <!-- 查看群成员 -->
      <i
        v-if="chat.theContact.type === RoomType.GROUP"
        class="flex-row-c-c grid-gap-2 btn-primary"
        transition="all  op-60 group-hover:op-100 300  cubic-bezier(0.61, 0.225, 0.195, 1.3)"
        i-solar:users-group-two-rounded-bold-duotone
        p-2.2 @click="setting.isOpenGroupMember = !setting.isOpenGroupMember"
      />
    </h4>
    <!-- 消息列表 -->
    <div class="relative flex-1 bg-light-5 shadow-sm dark:bg-dark-9">
      <el-scrollbar
        ref="scrollbarRef"
        class="stop-transition"
        wrap-class="h-65vh px-0 sm:px-2" view-class="msg-list h-65vh"
      >
        <ChatMessageList
          v-if="chat.theContact.roomId" ref="ChatMessageListRef" class="pb-8.5rem pt-2rem sm:pb-9rem"
          @scroll-bottom="scrollBottom"
        />
        <div v-else class="h-full w-full flex items-center justify-center">
          开启聊天吧
        </div>
      </el-scrollbar>
      <!-- 发送 -->
      <ChatMsgForm class="absolute bottom-0 left-0 z-2" @submit="onSendMsg" />
    </div>
  </div>
</template>

<style lang="scss" scoped>
:deep(.el-scrollbar) {
  .el-scrollbar__bar {
    opacity: 0.6;
  }
}
// .stop-transition {
//     filter: none !important;
//   transition: none !important;
//   * {
//     transition: none !important;
//     filter: none !important;
//   }
// }
</style>


