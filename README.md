<h2 align=center margin="10em" style="margin:4em;letter-spacing:0.3em;">
<img src="./public/images/logo/logo.png" width = "40" height = "40" alt="图片名称" align=center />
极物圈聊天应用</h2>

###  介绍
极物圈是一个综合性平台，集商城和社交功能于一体。在这个平台上，用户可以轻松购买虚拟商品，并且可以发布个人帖子，与他人互动，进行评论等。该平台注重用户体验，为用户提供了一个在你圈子交流、好物推荐、分享和购物的多功能环境。
###  技术

```
基于Nuxt3 + element-plus + pinia 基本框架
```

<!-- ###  体验
[<img src="./public/images/logo/logo.png" width = "20" height = "20" alt="图片名称" align=center /> 极物圈 —— 体验入口](https://jiwu.netlify.app) -->


###  项目截图
- 聊天桌面应用 Chat
 
![主页](./.doc/chat-el.png)

- 全局夜间模式 Light / Dark

![暗黑](./.doc/chat-el2.png)

- 聊天社交

![暗黑](./.doc/chat-el3.png)

- AI购物聊天

![暗黑](./.doc/chat-el4.png)

- 响应式

<img src="./.doc/chat-el5.png" width = "300" alt="响应式" align=center />


## ⏳ 起步 | Project Setup 

```sh
# node 版本 >= 16
npm install -g pnpm
pnpm install
# 一键运行
npm run install
```

### ✨ 开发

```sh
pnpm run dev
```

### 📦 打包

```sh
pnpm run build
```

### ❌ pnpm install error

查看源

```sh
pnpm get registry 
```

临时修改
```sh
pnpm --registry https://registry.npm.taobao.org install any-touch
```

持久使用
```sh
pnpm config set registry https://registry.npm.taobao.org
```

还原
```sh
pnpm config set registry https://registry.npmjs.org
```