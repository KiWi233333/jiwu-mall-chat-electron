// const AuthRoute = [
//   /^\/user\/*/,
//   /^\/order\/*/,
//   /^\/shopcart\/*/,
// ];
// 路由中间件
export default defineNuxtRouteMiddleware((to) => {
  const user = useUserStore();
  if (to.path === "/login")
    return;
  if (user.getToken === "" || !user.isLogin) {
    user.showLoginForm = true;
    // abortNavigation("还未登录！");
    return "/login";
  }
});
