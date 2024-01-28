<script lang="ts" setup>
import { RoomType } from "@/composables/api/chat/contact";

const activeMenu = ref("all");
const menuList = ref<{
  name: string
  title: string
  dto?: ChatContactPageDTO
}[]>([
  {
    name: "all",
    title: "全部",
  },
  {
    name: "group",
    title: "群聊",
    dto: {
      type: RoomType.GROUP,
    },
  },
  {
    name: "self",
    title: "个人",
    dto: {
      type: RoomType.SELFT,
    },
  },
]);
export interface ChatContactPageDTO {
  type: RoomType
}
const setting = useSettingStore();
</script>

<template>
  <div
    class="group absolute z-4 h-full max-w-100vw w-0 flex-shrink-0 overflow-hidden transition-300 transition-property-all sm:(relative left-0 top-0 w-1/4 card-default pl-0) bg-color"
    :class="setting.isOpenContact ? (setting.showChatMenu ? 'w-0' : 'pl-4.5rem w-full sm:w-1/4') : ''"
  >
    <ChatContactList class="h-full p-4" />
  </div>
</template>
