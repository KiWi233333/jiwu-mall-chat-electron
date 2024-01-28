<script lang="ts" setup>
/**
 * 文本消息
 */
const props = defineProps<{
  data: ChatMessageVO<TextBodyMsgVO>
  index: number
}>();

const { data } = toRefs(props);
const chat = useChatStore();
const user = useUserStore();
const nowDate = Date.now();

function getTime(time: string) {
  return (nowDate - +time) > 24 * 3600
    ? useDateFormat(time, "YYYY-MM-DD HH:mm:ss").value.toString()
    : useDateFormat(time, "HH:mm:ss").value.toString()
  ;
}

const isSelf = computed(() => props.data?.fromUser?.userId === user?.userInfo.id);

// 具体
const body: Partial<TextBodyMsgVO> | undefined = props.data.message?.body || {};

// @人
const getAtText = computed(() => {
  if (body?.atUidList && body?.atUidList.length > 0)
    return chat.onOfflineList.filter(item => body?.atUidList?.includes(item.userId)).map(item => `@${item.nickName}`).join("、");
  else
    return "";
});
</script>

<template>
  <div
    v-bind="$attrs"
    :label="data.roomId"
    class="max-w-3/4 w-fit flex gap-4 p-2 py-3"
    :class="isSelf ? 'self pl-2em  sm:pl-5em ' : 'pr-2em sm:pr-5em'"
  >
    <CardElImage :src="BaseUrlImg + data.fromUser.avatar" fit="cover" class="avatar h-2.4rem w-2.4rem flex-shrink-0 rounded-1/2 object-cover border-default" />
    <!-- 消息体 -->
    <div class="flex flex-col">
      <!-- 头像 -->
      <div class="mb-2 block flex flex-row items-center gap-2">
        <small>{{ data.fromUser.nickName }}</small>
        <el-tag v-if="data.fromUser.userId === user.userInfo.id" class="op-80" effect="dark" size="small">
          自己
        </el-tag>
      </div>
      <!-- 内容 -->
      <p transform-origin-ct transition-300 transition-transform active:scale-95 class="self-child msg-popper w-fit p-2 px-4 leading-1.2em shadow-sm card-default">
        {{ data.message.content }}
      </p>
      <!-- AT @ -->
      <small v-if="body?.atUidList && body?.atUidList.length" mt-2 class="flex-ml-a w-fit cursor-pointer truncate px-2 py-1 op-70 border-default card-default">
        {{ getAtText }}
      </small>
      <!-- 回复 -->
      <small v-if="body?.reply" mt-2 class="cursor-pointer truncate px-2 py-1 op-70 border-default card-default" @click="chat.scrollReplyMsg(body?.reply?.id, body?.reply?.gapCount)">
        回复: {{ `${body.reply.nickName}:${body.reply?.body || ''}` }}
      </small>
    </div>
  </div>
  <p v-if="index % 8 === 0" w-full py-2 text-center text-0.8em op-80>
    {{ getTime(data.message.sendTime) }}
  </p>
</template>

<style lang="scss" scoped>
.reply-shaing {
  --at-apply: 'rounded-6px w-full bg-[var(--el-color-primary-light-5)] animate-pulse animate-duration-1200 transition-all';
}
.msg-popper {
  border-radius:4px 1rem  1rem 1rem ;
}
.self {
  margin-left: auto;
  .flex-ml-a {
    margin-left: auto;
  }
  .flex-row {
    margin-left: auto;
    flex-direction: row-reverse;
  }
  flex-direction: row-reverse;
  .self-child {
    margin-left: auto;
  }
  .flex-col {
    justify-content: right;
  }
  .msg-popper {
    border-radius: 1rem 4px 1rem 1rem;
  }

}
</style>
