<script lang="ts" setup>
import currency from "currency.js";
import type { ShopcartVO } from "~/composables/api/shopcart";
import { updateShopcart } from "~/composables/api/shopcart";
import type { GoodsSkuVO } from "~/composables/api/goods/sku";
import { getGoodsSkuByGid } from "~/composables/api/goods/sku";

const { shopCart } = defineProps<{
  shopCart: ShopcartVO
}>();
const shop = useShopStore();
const user = useUserStore();
const isUpdateLoading = ref<boolean>(false);
const isLoading = ref<boolean>(true);
// 获取分页信息
const skuList = ref<GoodsSkuVO[]>([]);
const selectShopcartId = ref<string>(shopCart.id);

// 改变规格
watch(
  shopCart,
  (vo: ShopcartVO) => {
    changeUpdateShopcart(vo.skuId, vo.quantity);
  },
  { deep: true },
);

async function changeUpdateShopcart(skuId: string, quantity: number) {
  if (isUpdateLoading.value || !quantity)
    return;
  isUpdateLoading.value = true;
  const data = await updateShopcart(
    selectShopcartId.value,
    {
      skuId,
      quantity,
    },
    user.getToken,
  );
  if (data.code !== StatusCode.SUCCESS) {
    ElMessage.closeAll();
    ElMessage.error("修改失败，稍后重试！");
  }
  else {
    shopCart.skuId = skuId;
    shopCart.quantity = quantity;
  }
  const timer = setTimeout(() => {
    isUpdateLoading.value = false;
    clearTimeout(timer);
  }, 300);
}

// 加载规格列表
async function loadGoodSkuList(val: boolean) {
  if (val && isLoading.value) {
    const { data } = await getGoodsSkuByGid(shopCart.goodsId);
    setTimeout(() => {
      data.value?.data.forEach(p => skuList.value.push(p));
      isLoading.value = false;
    }, 300);
  }
}
// 计算规格全部属性
function getSkuProps(goodsSku: GoodsSkuVO) {
  return `${goodsSku.size || ""} ${goodsSku.color || ""} ${goodsSku.combo || ""}`;
}

// const propsText = ref<string>(
//   `${shopCart.size || ''} ${shopCart.color || ''} ${shopCart.combo || ''}`,
// );

// 用户
const getProps = computed({
  get() {
    return `${shopCart.size || ""} ${shopCart.color || ""} ${shopCart.combo || ""}`;
  },
  set(skuId: string) {
    const p = toRaw(skuList.value.find(p => p.id === skuId));
    // 更新
    if (p) {
      shopCart.size = p.size;
      shopCart.image = p.image;
      shopCart.price = p.price;
      shopCart.costPrice = p.costPrice;
      shopCart.color = p.color;
      shopCart.combo = p.combo;
      shopCart.skuId = skuId;
    }
  },
});

// 删除单个
function deleteShopCart() {
  ElMessageBox({
    title: "删除提示",
    message: "确定要删除吗？",
    type: "warning",
    showClose: false,
    lockScroll: false,
    customClass: "text-center",
    showCancelButton: true,
    cancelButtonText: "取 消",
    confirmButtonText: "删 除",
  })
    .then(async (res) => {
      if (res === "confirm") {
        const flag = await shop.deleteShopCartById(shopCart.id);
        if (flag)
          ElMessage.success("删除成功！");
        else
          ElMessage.error("删除错误，请稍后再试试看！");
      }
    })
    .catch();
}
</script>

<template>
  <div
    v-loading="isUpdateLoading"
    class="group mb-3 mt-2 flex-row-bt-c cursor-pointer border-2px rounded-6px transition-300 hover:shadow"
    border-dashed p-0 pr-2 border-default md:p-4
    hover:border="solid [var(--el-color-primary)]"
    dark:hover:bg="dark-1"
  >
    <NuxtLink :to="`/goods/detail/${shopCart.goodsId}`">
      <card-el-image
        loading="lazy"
        transition-300
        hover:transform-scale-110 :src="BaseUrlImg + shopCart.image"
        style="width: 8em; height: 8em; border: 1px solid #eee; border-radius: 4px"
        fit="cover"
      />
    </NuxtLink>
    <div
      style="width: 78%; height: 100%"
      group flex flex-col items-start justify-between overflow-hidden truncate px-4
    >
      <h3
        max-w-12em tracking-1px md:max-w-16em
        class="... overflow-hidden truncate"
      >
        {{ shopCart.name }}
      </h3>
      <!-- 中下 -->
      <p
        mb-5 mt-1 font-700 color-red-6
      >
        ￥{{ currency(shopCart.price) }}
        <span

          text-0.9em color-coolgray
          style="text-decoration: line-through"
        >
          ￥{{ currency(shopCart.costPrice) }}
        </span>
      </p>
      <!-- 下 -->
      <p
        flex-row-bt-c
        class="mt-2 w-1/1"
      >
        <ClientOnly>
          <el-select
            v-model="getProps"
            no-data-text="暂无其他规格！"
            loading-text="加载中..."
            :loading="isLoading"
            :placeholder="getProps"
            collapse-tags-tooltip
            class="mr-2"
            size="small"
            @visible-change="loadGoodSkuList"
          >
            <!-- value 内容 -->
            <el-option
              v-for="p in skuList"
              :key="p.id"
              :label="getSkuProps(p)"
              :value="p.id"
              :disabled="p.stock === 0"
            />
          </el-select>
        </ClientOnly>
        <!-- 数量 -->
        <el-input-number
          v-model="shopCart.quantity"
          size="small"
          :min="1"
          :max="99"
        />
      </p>
    </div>
    <div


      relative flex flex-1 flex-col items-center
    >
      <span


        i-solar:trash-bin-minimalistic-bold-duotone


        absolute p-3 opacity-0 transition-300 dark:bg-light group-hover:opacity-80 style="top: -3em"
        @click="deleteShopCart"
      />
      <slot name="btn" />
    </div>
  </div>
</template>

<style scoped lang="scss">
:deep(.el-input-number) {
  .el-input__inner {
    width: 1em;
  }
}
</style>
