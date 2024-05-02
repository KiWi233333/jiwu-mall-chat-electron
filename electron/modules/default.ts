import * as path from "node:path";
import { type BrowserWindow, Menu, Tray, app, ipcMain, nativeTheme } from "electron";
export function setMainOption(mainWindow: BrowserWindow) {
  /**
   * 窗口
   */
  onWindowOptions(mainWindow);
  /**
   * 初始化隐藏任务栏菜单
   */
  onInitTray(mainWindow);

  /**
   * 设置小窗功能按键
   */
  setPreWindowOpt(mainWindow);
}

export function setIPCOptions() {
  /**
   * 主题
   */
  onThemeToggle();
}


function onThemeToggle() {
  ipcMain.handle("dark-mode:toggle", (e, theme?: "system" | "light" | "dark" | any) => {
    if (theme === "auto") {
      const date = new Date();
      const hour = date.getHours();
      nativeTheme.themeSource = (hour >= 6 && hour <= 18) ? "light" : "dark";
      return nativeTheme.shouldUseDarkColors;
    }

    if (nativeTheme.shouldUseDarkColors)
      nativeTheme.themeSource = theme || "light";
    else
      nativeTheme.themeSource = theme || "dark";
    return nativeTheme.shouldUseDarkColors;
  });

  ipcMain.handle("dark-mode:isDark", () => {
    return nativeTheme.shouldUseDarkColors;
  });

  ipcMain.handle("dark-mode:system", () => {
    nativeTheme.themeSource = "system";
  });
}


function onWindowOptions(mainWindow: BrowserWindow) {
// 接收最小化命令
  ipcMain.handle("window-toggle", (e, type: "min" | "max" | "close") => {
    if (type === "max") {
      if (mainWindow.isMaximized())
        mainWindow.unmaximize();
      else
        mainWindow.maximize();

      return mainWindow.isMaximized();
    }
    else if (type === "min") {
      mainWindow.minimize();
    }
    else if (type === "close") {
      mainWindow.close();
    }
  });
}

function onInitTray(mainWindow: BrowserWindow) {
  // 创建任务栏图标
  const tray = new Tray(path.join(__dirname, "../../public/logo.png"));
  tray.setToolTip("极物圈"); // 设置鼠标指针在托盘图标上悬停时显示的文本
  // 自定义托盘图标的内容菜单
  tray.setContextMenu(Menu.buildFromTemplate([
    {
      label: "重启",
      role: "reload",
      click() {
        mainWindow.reload();
      },
    },

    {
      label: "全屏",
      role: "togglefullscreen",
      click() {
        mainWindow.fullScreen = !mainWindow.fullScreen;
      },
    },

    {
      label: "退出应用",
      role: "quit",
      click() {
        mainWindow.destroy();
        app.quit();
      },
    },
  ])); // 设置图标的内容菜单
  // 点击托盘图标，显示主窗口
  tray.on("click", () => {
    mainWindow.show();
  });
}


// 设置小窗 按钮
function setPreWindowOpt(win: BrowserWindow) {
// 预览小窗
  win.setThumbarButtons([
    // {
    //   tooltip: "button1",
    //   icon: nativeImage.createFromPath(path.join(__dirname, "button1.png")),
    //   click() { console.log("button1 clicked"); },
    // },
    // {
    //   tooltip: "button2",
    //   icon: nativeImage.createFromPath(path.join(__dirname, "button2.png")),
    //   flags: ["enabled", "dismissonclick"],
    //   click() { console.log("button2 clicked."); },
    // },
  ]);
}
