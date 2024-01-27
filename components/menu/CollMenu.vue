<script lang="ts" setup>
defineEmits(["close"]);
// 路由
const route = useRoute();

const menuList = [
  {
    title: "个人",
    path: "/user/info",
    icon: "i-solar:user-broken",
    activeIcon: "i-solar:user-bold-duotone",
  },
  {
    title: "我的帖子",
    path: "/user/post",
    icon: "i-solar:cup-hot-broken",
    activeIcon: "i-solar:cup-hot-bold-duotone ",
  },
  {
    title: "购物车",
    path: "/user/shopcart",
    icon: "i-solar:cart-large-2-linear",
    activeIcon: "i-solar:cart-large-2-bold",
  },
  {
    title: "我的收藏",
    path: "/user/collect",
    icon: "i-solar:star-broken",
    activeIcon: "i-solar:star-bold-duotone ",
  },
  {
    title: "钱包账单",
    path: "/user/wallet",
    icon: "i-solar:wallet-broken",
    activeIcon: "i-solar:wallet-bold-duotone",
  },
  {
    title: "收货地址",
    path: "/user/address",
    icon: "i-solar:compass-broken",
    activeIcon: "i-solar:compass-bold-duotone",
  },
  {
    title: "账号与安全",
    path: "/user/safe",
    icon: "i-solar:danger-broken",
    activeIcon: "i-solar:danger-bold-duotone",
  },
  {
    title: "回到首页",
    path: "/",
    icon: "i-solar:logout-3-broken",
  },
];
const setting = useSettingStore();
</script>

<template>
  <div
    class="menu fixed z-998 h-full bg-light bg-opacity-80 backdrop-blur-30 md:sticky md:block dark:bg-[#121212] md:shadow-none"
  >
    <ClientOnly>
      <!-- 菜单 -->
      <el-menu
        :router="true"
        :default-active="route.path"
        :collapse="setting.isUserFold"
      >
        <!-- 顶部 -->
        <div class="w-full flex-row-c-c flex-wrap px-5 transition-300 transition-300 hover:bg-transparent">
          <div class="home mt-6 self-center transition-300">
            <NuxtLink
              to="/"
              flex-row-c-c
              class="group"
            >
              <i class="i-solar:home-2-broken" />
            </NuxtLink>
          </div>
          <div class="float-left ml-a ml-a mt-6">
            <BtnBell transition="fade" trigger="click" class="animate-[0.2s_zoom-in]" placement="right-end" />
          </div>
          <span
            class="mt-6 p-1 transition-300"
            :class="setting.isUserFold ? 'hover:rotate-15' : 'hover:-rotate-15'"
            @click="setting.isUserFold = !setting.isUserFold"
          >
            <i class="i-solar:signpost-2-line-duotone" cursor-pointer p-0.6em />
          </span>
        </div>
        <div class="mx-a my-4 w-5/6 border-0 border-b-1px border-default" />
        <!-- 个人信息 -->
        <el-menu-item
          v-for="p in menuList"
          :key="p.path"
          :index="p.path"
        >
          <i
            v-show="route.path !== p.path"
            class="icon"
            :class="p.icon"
          />
          <i
            v-show="route.path === p.path"
            class="icon"
            :class="p.activeIcon"
          />
          <span class="title overflow-hidden px-6 font-500 tracking-0.2em">{{ p.title }}</span>
        </el-menu-item>
      </el-menu>
    </ClientOnly>
    <div
      class="bg"
      @click="$emit('close')"
    />
  </div>
</template>

<style lang="scss" scoped>
.menu {
  user-select: none;
  top: $top-nav-height;
  height: calc(100vh - $top-nav-height);

  :deep(.el-menu--popup-container),
  :deep(.el-menu) {
    height: 100%;

    .el-menu-item {
      position: relative;
      padding: 0.8em;
      padding-top: 0;
      padding-bottom: 0;
      overflow: hidden;
      text-overflow: clip;
      height: 3em;
      border-radius: 8px;
      margin: 10px;
      transition: $transition-delay;
      border: 1px dashed transparent;

      span {
        overflow: hidden;
        text-overflow: ellipsis;
        transition: 100ms;
      }

      &:hover,
      &.is-active:hover,
      &.is-active {
        border: 1px solid;
        color: var(--el-color-primary);
        background-color: var(--el-color-primary-light-9);

        i {
          color: var(--el-color-primary);
        }
      }

      &:hover {
        border: 1px dashed;
      }
    }

    .el-menu-item-group {
      .el-menu-item {
        background-color: #8181811a;
        opacity: 0.9;

        &:hover {
          background-color: #8181811a;
          opacity: 1;
        }

        .second-icon {
          padding: 2px;
        }
      }

      .el-menu-item:hover {
        background-color: transparent;
        color: var(--el-color-primary);
      }

      .el-menu-item-group__title ml-2 {
        display: none;
      }
    }

    // 图标
    .icon {
      padding: 0.7em;

      &:hover {
        transition: $transition-delay;
        color: var(--el-color-primary);
      }
    }


  }
}

@media screen and (width <= 768px) {
  .menu-bg .bg {
    content: "";
    position: absolute;
    left: 0;
    top: 0;
    width: 150vw;
    overflow: hidden;
    height: 100vh;
    background-color: rgb(51 51 51 / 30%);
    z-index: -1;
    transition: $transition-delay;
  }
}

:deep(.el-menu){
  .el-menu-item.is-active.is-active{
    &,
    &:hover{
      .icon ,
      .title {
        color: #fff;
      }
      border-color: var(--el-color-primary-light-7);
      background-color: var(--el-color-primary);
    }
    border-color: var(--el-color-primary-light-7);
  }
}
</style>
