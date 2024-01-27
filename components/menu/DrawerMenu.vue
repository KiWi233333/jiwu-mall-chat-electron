<script lang="ts" setup>
const setting = useSettingStore();
const route = useRoute();
const path = ref(route.path);

watch(() => route.path, (val) => {
  path.value = val;
});
await setting.loadMenus();
</script>

<template>
  <div class="menu-list fixed left-0 z-998 block h-full md:sticky" :class="$attrs.class">
    <div
      v-show="!setting.isCollapse" class="mock fixed left-0 top-0 z-998 block h-full w-full backdrop-blur-2px sm:hidden"
      style="background-color: #85858510;" @click="setting.isCollapse = true"
    />
    <div
      class="menu relative top-0 z-998 animate-[300ms_fade-in] transition-200 md:shadow-none"
    >
      <Transition
        enter-active-class="animate-[fade-in-left_200ms]"
        leave-active-class="animate-fade-out-left animate-duration-100"
      >
        <el-scrollbar
          v-show="!setting.isCollapse"
          height="100%" wrap-class="px-3 bg-white backdrop-blur-30 dark:bg-dark-8 border-default border-0 border-r-1px dark:bg-dark-8"
        >
          <!-- 菜单 -->
          <el-menu
            class="menu-first"
            :default-active="path"
            :collapse="setting?.isFold"
            unique-open
            :router="true"
          >
            <!-- 顶部 -->
            <div
              class="sticky left-0 top-0 flex flex-wrap border-0 border-b-1px rounded-0 transition-200 transition-300 transition-all border-default hover:bg-transparent"
            >
              <img
                loading="lazy" alt="Design By Kiwi23333" src="/images/logo/logo_dark.png"
                class="filter-shadow m-3 block"
                :class="{
                  'mx-a': setting?.isFold,
                }" h-1.8rem w-1.8rem
              >
              <i
                class="i-solar:hamburger-menu-line-duotone m-3 ml-a block text-dark dark:text-light" inline-block h-1.6rem w-1.6rem
                cursor-pointer :class="{
                  'mx-a': setting?.isFold,
                }" @click="setting.isFold = !setting?.isFold"
              />
            </div>
            <!-- 递归生成菜单栏 -->
            <ClientOnly>
              <MenuLine v-for="data in setting.menuList" :key="data.url" :data="data" />
            </ClientOnly>
          </el-menu>
        </el-scrollbar>
      </Transition>
    </div>
    <!-- 折叠隐藏 -->
    <div
      flex-row-c-c cursor-pointer rounded-r-8px shadow-sm hover:-translate-x-1
      transition="all 300  cubic-bezier(0.61, 0.225, 0.195, 1.3)"
      class="absolute bottom-2rem h-3rem w-2rem pl-1 text-[var(--el-color-primary)] -right-2rem -translate-x-2"
      :class="{ ' bg-[var(--el-color-primary)] shadow-indigo-600 text-white': setting.isCollapse }"
      @click="setting.isCollapse = !setting.isCollapse"
    >
      <i
        transition="all 300  cubic-bezier(0.61, 0.225, 0.195, 1.3)" :class="{ 'rotate-180 text-white': setting.isCollapse }"
        i-solar:alt-arrow-left-bold p-3
      />
    </div>
  </div>
</template>

<style lang="scss" scoped>
/* stylelint-disable no-descending-specificity */
$rounded-default: 4px;
$item-height: 8px;

.menu-list {
  top: $top-nav-height;
  height: calc(100vh - $top-nav-height);
}

:deep(.el-menu):not(.el-menu--collapse) {
  width: 12rem;
  height: 100%;
  overflow: hidden;
}

.menu {
  height: calc(100vh - $top-nav-height);
  user-select: none;

  :deep(.el-scrollbar__thumb) {
    width: 0;
  }

  :deep(.el-menu) {
    background-color: transparent;

    &.menu-first {
      border: none;
      // display: grid;
      // grid-template-columns: 1fr;
      // grid-gap: 0.5em;
    }

    &.el-menu--collapse {

      .is-active>.el-sub-menu__title {
        transition: all 0.2s;
        border: 1px dashed var(--el-color-primary);
        box-shadow: rgb(0 0 0 / 12%) 0 1px 3px, rgb(0 0 0 / 20%) 0 1px 2px;
        color: var(--el-color-primary);

      }
    }


    &.el-menu--popup {
      padding: 0.2rem;
    }

    // 二级
    .is-opened {
      border-radius: $rounded-default;
    }

    --el-menu-base-level-padding: 0.8em;

    // 菜单单项
    &.el-menu--collapse {

      .el-menu-item,
      .el-sub-menu__title {
        margin:0;
        margin-bottom: 0.5em;
        margin-right: 2px;
        width: 3rem;
        transition: all 0.2s;
        display: flex;
        align-items: center;
        justify-content: center;
      }
    }

    .el-menu-item,
    .el-sub-menu__title {
      margin:0;
      margin-bottom: 0.5em;
      margin-right: 2px;
      display: flex;
      align-items: center;
      justify-content: center;

      &.is-active {
        border: 1px solid var(--el-color-primary);
        box-shadow: rgb(0 0 0 / 12%) 0 1px 3px, rgb(0 0 0 / 20%) 0 1px 2px;
      }

      transition: all 0.2s;
      height: 2.8rem;
      border-radius: $rounded-default;
      border: 1px dashed transparent;

      &:hover {
        color: var(--el-color-primary);
        border-color: var(--el-color-primary);
      }
    }

    &.el-menu--inline {
      transition-property: all;
      // display: grid;
      // grid-template-columns: 1fr;
      // grid-template-rows: auto;
      // grid-gap: 0.4em;
      border-radius: $rounded-default $rounded-default;
      background-color: #4e4e4e0c;
      backdrop-filter: blur(12px);
      box-shadow: inset rgb(22 22 22 / 10%) 0 1px 3px, inset rgb(22 22 22 / 20%) 0 1px 2px;

      .el-menu-item {
        font-size: 0.8rem;
      }
    }

    .el-menu-item,
    .el-sub-menu {
      border: 1px dashed transparent;
      border-radius: $rounded-default;
    }
  }
}

:deep(.el-menu) {
  .el-menu-item.is-active {

    &,
    &:hover {
      color: #fff;
      background-color: var(--el-color-primary);
    }
  }

  .el-sub-menu__icon-arrow {
    position: absolute;
    right: 0.4rem;
  }
}

.dark {
  :deep(.el-menu) {

    .el-menu-item,
    .el-sub-menu__title {
      &.is-active {
        border: 1px solid var(--el-color-primary);
        box-shadow: rgb(138 138 138 / 12%) 0 1px 3px, rgb(110 110 110 / 20%) 0 1px 2px;
      }
    }
  }
}

// .el-menu--popup {
//   .is-active {
//     border: 1px dashed var(--el-color-primary);
//     box-shadow: rgb(0 0 0 / 12%) 0 1px 3px, rgb(0 0 0 / 20%) 0 1px 2px;
//     color: #fff !important;
//     background-color: var(--el-color-primary);
//   }
// }
</style>
