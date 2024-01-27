<script lang="ts" setup>
/**
 * 图片消息
 */
const props = defineProps<{
  data: ChatMessageVO<ImgBodyMsgVO>
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

// 具体
const body: Partial<ImgBodyMsgVO> | undefined = props.data.message?.body || {};
</script>

<template>
  <div
    v-bind="$attrs"
    :label="data.roomId"
    :class="{
      self: data?.fromUser?.userId === user?.userInfo.id,
    }"
    max-w-full w-fit flex gap-4 p-2 py-3 transition-300 transition-transform active:scale-95
  >
    <CardElImage :src="BaseUrlImg + data.fromUser.avatar" fit="cover" class="avatar h-2.4rem w-2.4rem rounded-1/2 object-cover border-default" />
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
      <div class="msg-popper w-fit" style="border-radius: 6px;">
        <CardElImage
          v-if="body.url" :src="BaseUrlImg + body.url"
          class="h-8rem w-8rem shadow-sm border-default v-card"
          preview-teleported
          :alt="body.url"
          :preview-src-list="[BaseUrlImg + body.url]"
        />
        <p w-fit p-2 leading-1.2em class="text msg-popper transform-origin-ct transition-300 transition-transform active:scale-95" card-default>
          {{ data.message.content }}
        </p>
      </div>
      <!-- 回复 -->
      <small v-if="body?.reply" mt-2 class="max-h-4rem max-w-20rem w-fit cursor-pointer break-words px-2 py-1 op-70 border-default card-default" @click="chat.scrollReplyMsg(body?.reply?.id, body?.reply?.gapCount)">
        <el-tag size="small">回复</el-tag>
        {{ `${body.reply.nickName}:${body.reply?.body || ''}` }}
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
.self {
  margin-left: auto;
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
  .text {
    margin-left: auto;
  }

}
.msg-popper {
  border-radius: 1rem 4px 1rem 1rem;
}
</style>
