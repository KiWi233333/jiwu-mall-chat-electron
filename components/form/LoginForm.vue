<script lang="ts" setup>
import {
  DeviceType,
  getLoginCodeByType,
  toLoginByEmail,
  toLoginByPhone,
  toLoginByPwd,
} from "~/composables/api/user";
import { LoginType } from "~/types/user/index.js";

const loginType = ref<number>(LoginType.EMAIL);
const isLoading = ref<boolean>(false);
const autoLogin = ref<boolean>(false);
// 表单
const initForm = {
  username: "ikun233", // 用户名
  password: "123456", // 密码
  phone: "", // 手机号
  email: "", // 邮箱
  code: "", // 验证码
};
const userForm = reactive({
  username: "ikun233", // 用户名
  password: "123456", // 密码
  phone: "", // 手机号
  email: "", // 邮箱
  code: "", // 验证码
});
const rules = reactive({
  username: [
    { required: true, message: "该项不能为空！", trigger: "blur" },
    { min: 6, max: 30, message: "长度在6-30个字符！", trigger: "blur" },
  ],
  password: [
    { required: true, message: "密码不能为空！", trigger: "blur" },
    { min: 6, max: 20, message: "密码长度6-20位！", trigger: "blur" },
    // {
    //   pattern: /^\w{6,20}$/,
    //   message: "密码字母数字下划线组成",
    //   trigger: "blur",
    // },
  ],
  code: [
    {
      required: true,
      message: "验证码6位组成！",
      trigger: "change",
    },
  ],
  email: [
    { required: true, message: "邮箱不能为空！", trigger: "blur" },
    {
      pattern:
        /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
      message: "邮箱格式不正确！",
      trigger: "blur",
    },
  ],
  phone: [
    { required: true, message: "手机号不能为空！", trigger: "blur" },
    {
      pattern:
        /^(?:(?:\+|00)86)?1(?:(?:3[\d])|(?:4[5-79])|(?:5[0-35-9])|(?:6[5-7])|(?:7[0-8])|(?:8[\d])|(?:9[1589]))\d{8}$/,
      message: "手机号格式不正确！",
      trigger: "change",
    },
  ],
});
// 验证码有效期
const phoneTimer = ref(-1);
const emailTimer = ref(-1);
const emailCodeStorage = ref<number>(0);
const phoneCodeStorage = ref<number>(0);

/**
 * 获取验证码
 * @param type
 */
async function getLoginCode(type: LoginType) {
  let data;
  // 获取邮箱验证码
  if (type === LoginType.EMAIL) {
    // 简单校验
    if (userForm.email.trim() === "")
      return;
    if (!checkEmail(userForm.email)) {
      isLoading.value = false;
      return ElMessage.error("邮箱格式不正确！");
    }
    // 开启
    isLoading.value = true;
    // 请求验证码
    data = await getLoginCodeByType(userForm.email, DeviceType.EMAIL);
    // 成功
    if (data.code === StatusCode.SUCCESS) {
      ElMessage.success({
        message: "验证码已发送至您的邮箱，5分钟有效！",
        duration: 5000,
      });
      useInterval(emailTimer, emailCodeStorage, 60, -1);
    }
  }
  // 获取手机号验证码
  else if (type === LoginType.PHONE) {
    if (userForm.phone.trim() === "")
      return;
    if (!checkPhone(userForm.phone)) {
      isLoading.value = false;
      ElMessage.closeAll("error");
      return ElMessage.error("手机号格式不正确！");
    }
    isLoading.value = true;
    data = await getLoginCodeByType(userForm.phone, DeviceType.PHONE);
    if (data.code === 20000) {
      // 开启定时器
      useInterval(phoneTimer, phoneCodeStorage, 60, -1);
      ElMessage.success({
        message: data.message,
        duration: 5000,
      });
      // userForm.code = data.data;
    }
    else {
      ElMessage.closeAll("error");
      ElMessage.error(data.message);
    }
  }
  // 关闭加载
  isLoading.value = false;
}
/**
 * 定时器
 * @param timer 本地定时器
 * @param num 计数对象
 * @param target 开始秒数
 * @param step 自增自减
 * @param fn 回调
 */
function useInterval(timer: any,
  num: Ref<number>,
  target?: number,
  step = -1,
  fn?: () => void) {
  num.value = target || timer.value;
  timer.value = setInterval(() => {
    num.value += step;
    // 清除定时器
    if (num.value <= 0) {
      num.value = -1;
      clearInterval(timer.value);
      timer.value = -1;
    }
    fn && fn();
  }, 1000);
}

const store = useUserStore();
function toRegister() {
  store.showLoginForm = false;
  store.showRegisterForm = true;
}

const formRef = ref();
/**
 * 登录
 * @param formEl 表单示例
 */
async function onLogin(formEl: any | undefined) {
  if (!formEl || isLoading.value)
    return;
  formEl.validate(async (valid: boolean) => {
    if (!valid)
      return;
    isLoading.value = true;
    let res = { code: 20001, data: "", message: "登录失败！" };
    try {
      switch (loginType.value) {
        case LoginType.PWD:
          res = await toLoginByPwd(userForm.username, userForm.password);
          break;
        case LoginType.PHONE:
          res = await toLoginByPhone(userForm.phone, userForm.code);
          break;
        case LoginType.EMAIL:
          res = await toLoginByEmail(userForm.email, userForm.code);
          break;
      }
    }
    finally {
      isLoading.value = false;
    }
    if (res.code === 20000) {
      // 登录成功
      if (res.data !== "") {
        ElMessage.success({
          message: "登录成功！",
          duration: 2000,
        });
        store.onUserLogin(res.data, autoLogin.value);
        store.$patch({
          token: res.data,
          showLoginForm: false,
          showRegisterForm: false,
          isLogin: true,
        });
      }
      // 登录失败
      else {
        ElMessage.error({
          message: res.message,
          duration: 5000,
        });
        // store
        store.$patch({
          token: "",
          isLogin: false,
        });
      }
    }
    setTimeout(() => {
      isLoading.value = false;
    }, 300);
  });
}
</script>

<template>
  <!-- 登录 -->
  <el-form
    ref="formRef"
    v-loading="isLoading"
    label-position="top"
    hide-required-asterisk
    :rules="rules"
    :model="userForm"
    class="form animate__animated w-94vw sm:w-400px"
  >
    <h2
      mb-5
      mt-4
      tracking-0.2em
    >
      欢迎来到极物圈🎉
    </h2>
    <p
      mb-10 text-0.8em tracking-0.1em
    >
      没有账户？
      <span
        cursor-pointer color-emerald transition-300 hover:font-700
        @click="toRegister"
      >
        立即注册
      </span>
    </p>
    <!-- 切换登录 -->
    <div
      class="toggle-login"
      my-1em
    >
      <el-button
        flex-1
        :class="{ active: loginType === LoginType.EMAIL }"
        tracking-0.1em
        @click="loginType = LoginType.EMAIL"
      >
        邮箱登录
      </el-button>
      <el-button
        flex-1
        :class="{ active: loginType === LoginType.PHONE }"
        tracking-0.1em
        @click="loginType = LoginType.PHONE"
      >
        手机登录
      </el-button>
      <el-button
        flex-1
        :class="{ active: loginType === LoginType.PWD }"
        tracking-0.1em
        tracking-0.2em
        @click="loginType = LoginType.PWD"
      >
        密码登录
      </el-button>
    </div>
    <!-- 验证码登录(客户端 ) -->
    <ClientOnly>
      <!-- 邮箱登录 -->
      <el-form-item
        v-if="loginType === LoginType.EMAIL"
        prop="email"
        class="animated"
      >
        <el-input
          v-model.trim="userForm.email"
          type="email"
          prefix-icon="Message"
          size="large"
          placeholder="请输入邮箱"
          @keyup.enter="getLoginCode(loginType)"
        >
          <template #append>
            <el-button
              type="primary"
              :disabled="phoneCodeStorage > 0 && isLoading"
              @click="getLoginCode(loginType)"
            >
              {{ emailCodeStorage > 0 ? `${emailCodeStorage}s后重新发送` : "获取验证码" }}
            </el-button>
          </template>
        </el-input>
      </el-form-item>
      <!-- 手机号登录 -->
      <el-form-item
        v-if="loginType === LoginType.PHONE"
        type="tel"
        prop="phone"
        class="animated"
      >
        <el-input
          v-model.trim="userForm.phone"
          prefix-icon="Iphone"
          size="large"
          type="tel"
          placeholder="请输入手机号"
          @keyup.enter="getLoginCode(loginType)"
        >
          <template #append>
            <el-button
              type="primary"
              :disabled="phoneCodeStorage > 0"
              @click="getLoginCode(loginType)"
            >
              {{ phoneCodeStorage > 0 ? `${phoneCodeStorage}s后重新发送` : "获取验证码" }}
            </el-button>
          </template>
        </el-input>
      </el-form-item>
    </ClientOnly>
    <el-form-item
      v-if="loginType === LoginType.EMAIL || loginType === LoginType.PHONE"
      prop="code"
      class="animated"
    >
      <el-input
        v-model.trim="userForm.code"
        prefix-icon="ChatDotSquare"
        size="large"
        placeholder="请输入验证码"
        @keyup.enter="onLogin(formRef)"
      />
    </el-form-item>
    <!-- 密码登录 -->
    <el-form-item
      v-if="loginType === LoginType.PWD"
      label=""
      prop="username"
      class="animated"
    >
      <el-input
        v-model.trim="userForm.username"
        prefix-icon="user"
        size="large"
        placeholder="请输入用户名、手机号或邮箱"
        @keyup.enter="onLogin(formRef)"
      />
    </el-form-item>
    <el-form-item
      v-if="loginType === LoginType.PWD"
      type="password"
      show-password
      label=""
      prop="password"
      class="animated"
    >
      <el-input
        v-model.trim="userForm.password"
        prefix-icon="Lock"
        size="large"
        placeholder="请输入密码"
        show-password
        type="password"
        @keyup.enter="onLogin(formRef)"
      />
    </el-form-item>
    <el-form-item mt-1em>
      <el-button
        type="primary"
        class="submit w-full tracking-0.2em"
        style="padding: 20px"
        @keyup.enter="onLogin(formRef)"
        @click="onLogin(formRef)"
      >
        登录
      </el-button>
    </el-form-item>
  </el-form>
</template>

<style scoped lang="scss">
.form {
  display: block;
  padding: 2em 3em;
  background-color: #fff;
  border-radius: var(--el-border-radius-base);
  backdrop-filter: blur(5px);
  border: 1px solid rgb(109 109 109 / 20%);
  box-shadow: rgb(0 0 0 / 20%) 0 1px 4px;
  overflow: hidden;
  animation-delay: 0.1s;

  :deep(.el-input__wrapper) {
    padding: 0.3em 1em;
  }

  // 报错信息
  :deep(.el-form-item) {
    padding: 0.2em;

    .el-form-item__error {
      padding-top: 0.2em;
    }
  }
}

:deep(.el-button) {
  padding: 0.3em 1em;
}

.dark .form {
  background-color: #161616d8;
}

.animate__animated {
  animation-duration: 0.5s;
}

// label总体
:deep(.el-form-item) {
  margin-bottom: 14px;
}

// 切换登录
.toggle-login {
  position: relative;
  border-radius: var(--el-border-radius-base);
  backdrop-filter: blur(10px);
  background-color: #b3b3b32a;
  padding: 0.3em;
  display: flex;

  :deep(.el-button) {
    background-color: transparent;
    transition: 0.3s;
    padding: 0 0.6em;
    border: none;
  }

  .active {
    transition: 0.3s;
    background-color: #fff;
    z-index: 1;
    box-shadow: rgb(0 0 0 / 20%) 0 1px 4px;
    color: var(--el-text-color);
  }
}

.dark .active {
  background-color: var(--el-color-primary);
}

.submit {
  font-size: 1.2em;
  font-weight: 800;
  transition: 0.3s;
  cursor: pointer;

  :deep(.el-input__wrapper) {
    background-color: var(--el-color-primary);
    cursor: pointer;

    * {
      color: #fff;
      font-weight: 800;
      letter-spacing: 0.4em;
    }
  }

  .dark:deep(.el-input__wrapper) {
    background-color: var(--el-color-primary);
    cursor: pointer;
    color: #fff;
  }
}
</style>
