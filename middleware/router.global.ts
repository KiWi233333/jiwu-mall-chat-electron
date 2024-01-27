// const AuthRoute = [
//   /^\/user\/*/,
//   /^\/order\/*/,
//   /^\/shopcart\/*/,
// ];
// 路由中间件
export default defineNuxtRouteMiddleware((to) => {
  // const user = useUserStore();
  // if (AuthRoute.filter(p => p.test(to.path)).length > 0) {
  //   if (user.getToken === "" || !user.isLogin) {
  //     user.showLoginForm = true;
  //     abortNavigation();
  //   }
  // }
});
