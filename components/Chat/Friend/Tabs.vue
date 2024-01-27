<script lang="ts" setup>
const chat = useChatStore();
const ws = useWs();
function onNewView() {
  chat.setTheFriendOpt(FriendOptType.NewFriend, {});
  // 消费消息
  ws.wsMsgList.applyMsg.splice(0);
}
</script>

<template>
  <div
    class="border-0 border-r-1px transition-200 transition-width border-default"
    v-bind="$attrs"
  >
    <slot name="top">
      <div class="list">
        <div class="py-2 hover:bg-transparent">
          <ChatFriendApplySearch
            @submit="val => {
              chat.setTheFriendOpt(FriendOptType.User, val)
            }"
          />
        </div>
      </div>
      <div class="list">
        <small op-90>新的朋友</small>
        <div class="item" @click="onNewView">
          <el-badge :value="ws.wsMsgList.applyMsg.length || 0" :hidden="!ws.wsMsgList.applyMsg.length" :max="99">
            <div class="avatar-icon bg-[var(--el-color-warning)]">
              <i i-solar:user-plus-bold bg-light p-3 />
            </div>
          </el-badge>
          <small>新的朋友</small>
        </div>
      </div>
    </slot>
    <!-- 群聊 -->
    <div class="list pb-4">
      <small op-90>群聊</small>
      <ChatFriendGroupList />
    </div>
    <!-- 好友 -->
    <div class="list">
      <small op-90>好友</small>
      <ChatFriendList />
    </div>
  </div>
</template>

<style lang="scss" scoped>
.avatar-icon {
  --at-apply:"h-2.6rem  flex-row-c-c rounded-6px w-2.6rem shadow-sm border-default"
}
.list {
  --at-apply:"mb-5 flex flex-col pb-3 border-b-1px  border-default border-0"
}
.item {
  --at-apply:"flex items-center gap-4 p-2 cursor-pointer hover:(bg-[#b8b8b849] ) mt-2 rounded-6px transition-300"
}
</style>
