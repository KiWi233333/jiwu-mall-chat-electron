<script lang="ts" setup>
const isLoading = ref<boolean>(false);
const user = useUserStore();
const pageInfo = ref({
  cursor: null as null | string,
  isLast: false,
  size: 10,
  total: -1,
});
const list = ref<ChatUserFriendVO[]>([]);

// 加载数据
async function loadData() {
  if (isLoading.value || pageInfo.value.isLast)
    return;
  isLoading.value = true;
  const { data } = await getChatFriendPage(pageInfo.value.size, pageInfo.value.cursor, user.getToken);
  if (data.list)
    list.value.push(...data.list);
  pageInfo.value.isLast = data.isLast;
  pageInfo.value.cursor = data.cursor;
  isLoading.value = false;
}
loadData();
// 会话store
const chat = useChatStore();

watchDebounced(() => chat.delUserId, (val) => {
  if (val) {
    list.value = list.value.filter(p => p.userId !== val);
    chat.setDelUserId("");
  }
}, {
  debounce: 300,
});
</script>

<template>
  <el-radio-group class="w-full">
    <div w-full flex flex-col>
      <ListAutoIncre
        :immediate="true"
        :auto-stop="true"
        :no-more="pageInfo.isLast"
        :loading="isLoading"
        @load="loadData"
      >
        <div v-for="p in list" :key="p.uid">
          {{ p.nickName }}
          {{ p.activeStatus }}
        </div>
      </ListAutoIncre>
    </div>
  </el-radio-group>
</template>

<style lang="scss" scoped>
:deep(.el-radio-group) {
  display: block;
  padding: 0;
  font-size: 1rem;
  margin: 0;
  width: 100%;
}

:deep(.el-radio){
  width: 100%;
  height: fit-content;
  display: block;
  padding: 0;
  margin: 0;
  border-color: #adadad18;
    transition: 200ms border;
  margin-bottom: 1rem;
  .el-radio__input {
    display: none;
    border-color: transparent;
  }
  .el-radio__label {
    padding: 0;
  }
}
</style>
