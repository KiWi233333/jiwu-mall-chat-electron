<script lang="ts" setup>
import { type CommCommentInfo, type SelectCommPostCommentDTO, addCommComment } from "@/composables/api/community/comment";

const props = withDefaults(defineProps<{
  postId: string
  limit?: number
  dto?: SelectCommPostCommentDTO
  showMoreText?: boolean
}>(), {
  dto: () => {
    return {};
  },
  limit: undefined,
  showMoreText: true,
});
const form = ref({
  content: "",
  parentId: "",
  images: [] as string[],
});

// 表单实例
const formRef = ref();
const rules = ref();
const user = useUserStore();
// 功能
const isFormLoading = ref(false);
const isListLoading = ref(false);

// 帖子行为列表
// const postActionList = useAsyncData(async () => {
//   const { data, code } = await getPostActionById(props.postId, { }, user.getTokenFn());
//   if (code === StatusCode.SUCCESS)
//     return data;
//   else
//     return [];
// });


// 图片上传
const inputOssFileUploadRef = ref();
function onSubmitImages(key: string, pathList: string[], fileList: OssFile[]) {
  form.value.images = pathList.filter(p => p) as string[];
}

// 评论列表
const commentList = ref<CommCommentInfo[]>([]);
// 分页器
const page = ref<number>(0);
const size = ref<number>(props.limit || 10);
// 查询页信息
const pageInfo = reactive({
  total: -1,
  pages: -1,
  current: -1,
});
const toggleDTO = ref({
  isHot: undefined as number | undefined,
  isNew: undefined as number | undefined,
});

const isHotNew = ref("new");
watch(isHotNew, (val) => {
  if (val === "hot") {
    toggleDTO.value.isHot = isTrue.TRUE;
    toggleDTO.value.isNew = undefined;
  }
  else {
    toggleDTO.value.isHot = undefined;
    toggleDTO.value.isNew = isTrue.TRUE;
  }
  onReload();
});

const isEmpty = computed<boolean>(() => {
  return page.value >= 1 && pageInfo?.pages === 0 && commentList.value.length === 0;
});
const isNoMore = computed<boolean>(() => {
  return pageInfo.total >= 1 && pageInfo.current >= pageInfo.pages;
});

async function loadCommentsPage() {
  // 没有更多
  if (isListLoading.value || isNoMore.value || isEmpty.value) {
    isListLoading.value = false;
    return;
  }

  if (props.limit !== undefined && commentList.value.length >= props.limit) {
    isListLoading.value = false;
    return;
  }

  isListLoading.value = true;
  page.value++;
  const { data } = await getCommCommentPage(props.postId, page.value, size.value, {
    ...toggleDTO.value,
  } || {});
  // 展示结果
  pageInfo.total = data.total || 0;
  pageInfo.current = data.current || 0;
  pageInfo.pages = data.pages || 0;
  commentList.value.push(...data?.records || []);
  isListLoading.value = false;
}


// -----------------------评论------------------------
const commentRef = ref();
const thePosition = ref<number[]>([]);
const theComment = ref<CommCommentInfo>();
/**
 * 开始评论
 * @param pid 父id
 */
function showComment(pid: string, position?: number[], data?: CommCommentInfo) {
  if (pid) {
    form.value.parentId = pid;
    thePosition.value = position || [];
    commentRef.value?.focus();
    theComment.value = data;
  }
}


/**
 * 提交评论
 * @param parentId 父id
 */
function onSubmitComment(parentId?: string, position?: number[]) {
  formRef.value?.validate(async (valid: boolean) => {
    if (!valid) {
      commentRef?.value?.focus();
      return;
    }
    isFormLoading.value = true;
    const res = await addCommComment(props.postId, form.value, user.getToken);
    if (res.code === StatusCode.SUCCESS) {
      formRef.value?.resetFields();
      ElNotification.success("评论成功！");
      // 添加
      const info: CommCommentInfo = {
        ...res.data,
        user: {
          username: user.userInfo?.username,
          nickname: user.userInfo?.nickname,
          gender: user.userInfo?.gender,
          avatar: user.userInfo?.avatar,
          slogan: user.userInfo?.slogan,
          lastLoginIp: user.userInfo?.lastLoginIp,
          birthday: user.userInfo?.birthday,
        },
      };
      // 追加
      if (parentId && parentId !== "") {
        if (position && position.length > 0) {
          const theList = commentList.value;
          position.forEach((p, i) => {
            if (i + 1 === position.length) {
              if (theList[p] && theList[p].children && Array.isArray(theList[p].children))
                theList[p]?.children?.push(info);
              else
                theList[p].children = toReactive([info]);
            }
          });
        }
        else {
          commentList.value.unshift(info);
        }
        clearForm();
      }
      // 追加1级
      else {
        commentList.value.unshift(info);
      }
    }
    setTimeout(() => {
      isFormLoading.value = false;
      commentRef.value?.focus();
    }, 300);
  });
}

/**
 * 删除评论
 * @param commentId 评论id
 * @param position 位置下标
 */
function deleteComment(commentId: string, position?: number[]) {
  if (!commentId || !position)
    return;
  ElMessageBox.confirm(position.length ? "注意子评论也将会被删除！" : "是否删除评论？", "删除评论", {
    confirmButtonText: "删除",
    cancelButtonText: "取消",
    lockScroll: false,
    type: "warning",
    callback: async (action: string) => {
      if (action === "confirm") {
        isFormLoading.value = true;
        const res = await delCommComment(props.postId, commentId, user.getToken);
        if (res.code === StatusCode.SUCCESS) {
          if (position && position.length > 1) {
            let theList = commentList.value;
            position.forEach((p, i) => {
              if (i + 1 === position.length)
                theList?.splice(p, 1);
              else
                theList = theList[p].children as any[];
            });
          }
          else {
            commentList.value = commentList.value.filter((item: any) => item.id !== commentId);
          }
          ElMessage.info("删除成功！");
        }
        else {
          ElMessage.error(res.message);
        }
        clearForm();
        isFormLoading.value = false;
      }
    },
  });
}


// 清除表单
function clearForm() {
  form.value = {
    content: "",
    parentId: "",
    images: [],
  };
  thePosition.value.splice(0);
}

// 刷新
const isReload = ref(false);
function onReload() {
  if (isReload.value)
    return;
  isReload.value = true;
  page.value = 0;
  commentList.value = [];
  pageInfo.total = -1;
  pageInfo.pages = -1;
  pageInfo.current = -1;
  setTimeout(() => {
    loadCommentsPage();
    isReload.value = false;
  }, 300);
}

const parentIdList = computed(() => {
  return theComment.value?.id ? [theComment.value] : [];
});
</script>

<template>
  <div w-full>
    <div class="forms sticky bottom-1rem">
      <el-form
        ref="formRef"
        :disabled="isFormLoading"
        label-position="top"
        hide-required-asterisk
        :rules="rules"
        :model="form"
      >
        <div v-auto-animate w-full flex items-center>
          <CardElImage
            class="h-3rem w-3rem rounded-1/2 shadow-sm border-default v-card"
            fit="cover"
            :src="BaseUrlImg + user.userInfo?.avatar"
          />
          <el-form-item
            style="margin: 0.5rem 0;"
            prop="content"
            class="w-full pl-4"
            :rules="
              [{
                 required: true,
                 message: '评论内容不能为空！',
                 trigger: 'blur',
               },
               {
                 min: 2,
                 max: 50,
                 message: '评论内容不能为空评论长度为2-50字符！',
                 trigger: 'change',
               }]"
          >
            <el-input
              ref="commentRef"
              v-model.lazy="form.content"
              class="w-full"
              size="large"
              placeholder="说说你的心得 ~"
              @keyup.enter.self="onSubmitComment(form.parentId, thePosition)"
            />
          </el-form-item>
        </div>
        <!-- 提交 -->
        <div mt-4 flex-row-c-c grid-gap-4 class="select-parent">
          <i
            i-tabler:photo-plus ml-3 cursor-pointer p-0.7rem
            class="transition-200 hover:bg-[var(--el-color-info)]"
            @click="inputOssFileUploadRef?.inputRef?.click()"
          />
          <!-- 刷新 -->
          <i
            class="i-solar:refresh-outline block cursor-pointer p-0.6rem transition-300 hover:rotate-180 hover:bg-[var(--el-color-info)]" @click="onReload"
          />
          <!-- 父评论id -->
          <el-form-item
            prop="parentId"
            class="md:w-12rem"
            style="padding: 0;margin: 0;margin-left: 0.8rem;"
          >
            <el-select
              v-model="form.parentId"
              clearable
              placeholder="@回复"
              @clear="form.parentId = ''"
            >
              <el-option
                v-for="p in parentIdList"
                :key="p?.id"
                :label="p?.user?.nickname"
                :value="p?.id"
              />
            </el-select>
          </el-form-item>
          <el-select
            v-model="isHotNew"
            class="md:w-12rem"
            placeholder="排序方式"
            @change="onReload()"
          >
            <el-option
              label="最新排序"
              value="new"
            />
            <el-option
              label="最热排序"
              value="hot"
            />
          </el-select>
          <BtnElButton
            :disabled="isFormLoading"
            class="group ml-a animate-fade-in-left animate-ease-in-out"
            icon-class="i-solar:map-arrow-right-bold-duotone block  animate-zoom-in-left mr-1"
            round
            type="info"
            @click="onSubmitComment(form.parentId, thePosition)"
          >
            发送&nbsp;
          </BtnElButton>
        </div>
        <el-form-item
          style="margin: 0.5rem 0;"
          prop="images"
        >
          <!-- 图片上传 -->
          <div
            v-show="form.images?.length "
            v-auto-animate
          >
            <InputOssFileUpload
              ref="inputOssFileUploadRef"
              key="inputOssFileUploadRef"
              :multiple="true"
              :limit="3"
              input-class="w-8rem h-8rem mr-2 flex-row-c-c flex-shrink-0  v-card"
              :upload-quality="0.7"
              @error-msg="(msg:string) => {
                ElMessage.error(msg)
              }"
              @submit="onSubmitImages"
            />
          </div>
        </el-form-item>
      </el-form>
    </div>
    <ClientOnly>
      <template #fallback>
        <OtherPreLoading class="w-full" />
      </template>
      <!-- 评论列表 -->
      <div
        v-auto-animate="{
          duration: 200,
        }"
      >
        <ListAutoIncre
          :immediate="true"
          :auto-stop="false"
          :no-more="isNoMore || isEmpty"
          :loading="isListLoading && !isFormLoading"
          @load="loadCommentsPage"
        >
          <CommCommentCard
            v-for="(p, index) in commentList" :key="p.id"
            :position="[index]"
            :data="p"
            @comment="showComment"
            @delete="deleteComment"
          />
          <template #done>
            <NuxtLink
              v-if="limit !== undefined"
              :to="{
                path: `/community/post/detail/${postId}`,
              }"
              target="_blank"
              class="block w-full text-center text-0.8rem opacity-60 transition-200 hover:text-[var(--el-color-info)]"
            >
              {{ pageInfo.total > 0 ? `查看全部 ${pageInfo.total} 条评论` : '暂无评论，快去发表吧！' }}
            </NuxtLink>
            <small
              v-else
              class="block w-full text-center text-0.8rem opacity-60"
              @click="commentRef?.focus"
            >
              暂无{{ pageInfo.total > 0 ? `更多` : '评论，快去发表吧！' }}
            </small>
          </template>
        </ListAutoIncre>
      </div>
    </ClientOnly>
  </div>
</template>

<style scoped lang="scss">
.select-parent {
  :deep(.el-select) {
    .el-input__wrapper {
      background-color: transparent;
      border: 0;
      box-shadow: 1px 1px 2px transparent;

      &:hover {
        box-shadow: 1px 1px 2px var(--el-color-info-light-3),-1px -1px 2px var(--el-color-info-light-3);
      }
    }
  }
}
</style>
