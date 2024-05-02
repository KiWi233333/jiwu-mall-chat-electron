
import * as path from "node:path";
import * as os from "node:os";
import { BrowserWindow, app, ipcMain, nativeTheme, session } from "electron";

import singleInstance from "./singleInstance";
import dynamicRenderer from "./dynamicRenderer";
import titleBarActionsModule from "./modules/titleBarActions";
import updaterModule from "./modules/updater";
import macMenuModule from "./modules/macMenu";
import { setIPCOptions, setMainOption } from "./modules/default";

// 窗口管理
const BrowserWindowsMap = new Map<number, BrowserWindow>();
let mainWindowId: number;

// Initilize
// =========
process.env.ELECTRON_DISABLE_SECURITY_WARNINGS = "true";
const isPord = process.env.NODE_ENV !== "development";
const platform: "darwin" | "win32" | "linux" = process.platform as any;
const architucture: "64" | "32" = os.arch() === "x64" ? "64" : "32";
const headerSize = 32;
const modules = [titleBarActionsModule, macMenuModule, updaterModule];

// Initialize app window 创建初始化窗口
// =====================
function createWindow() {
  const mainWindow = new BrowserWindow({
    title: "极物圈",
    width: 1250,
    height: 920,
    minWidth: 425,
    minHeight: 676,
    frame: false, // 无边框
    titleBarStyle: "hidden", // 隐藏标题栏
    transparent: true, // 透明
    backgroundColor: "#00000000",
    webPreferences: {
      devTools: !isPord,
      nodeIntegration: true,
      contextIsolation: true,
      preload: path.join(__dirname, "preload.js"),
    },
    icon: path.join(__dirname, "../public/logo.png"), // 注意，这里的path是一个node模块哦，需要npm安装并且引入使用。最直接的作用就是拼接字符串。

  });

  // Lock app to single instance
  if (singleInstance(app, mainWindow))
    return;

  // Open the DevTools.
  !isPord
    && mainWindow.webContents.openDevTools({
      mode: "bottom",
    });

  return mainWindow;
}

// IPC
setIPCOptions();
// App events
// ==========
app.whenReady().then(async () => {
  if (!isPord) {
    try {
      await session.defaultSession.loadExtension(path.join(__dirname, "../..", "__extensions", "vue-devtools"));
    }
    catch (err) {
      console.log("[Electron::loadExtensions] An error occurred: ", err);
    }
  }
  // 创建
  const mainWindow = createWindow();
  if (!mainWindow)
    return;
  // 记录路由
  BrowserWindowsMap.set(mainWindow.id, mainWindow);
  mainWindowId = mainWindow.id;
  mainWindow.on("close", (e) => {
    e.preventDefault();
    mainWindow.setSkipTaskbar(true);
    mainWindow.hide();
  });
  mainWindow.on("closed", () => {
    BrowserWindowsMap?.delete(mainWindowId);
  });

  // 设置
  setMainOption(mainWindow);

  // Load renderer process
  dynamicRenderer(mainWindow);

  // Initialize modules
  console.log(`${"-".repeat(30)}\n[+] Loading modules...`);
  modules.forEach((module) => {
    try {
      module(mainWindow);
    }
    catch (err: any) {
      // console.log("[!] Module error: ", err.message || err);
    }
  });

  // console.log("[!] Loading modules: Done." + `\r\n${"-".repeat(30)}`);

  app.on("activate", () => {
    if (BrowserWindow.getAllWindows().length === 0)
      createWindow();
    else
      BrowserWindowsMap.get(mainWindowId)?.show();
  });
});


// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on("window-all-closed", () => {
  if (process.platform !== "darwin")
    app.quit();
});


// 任务栏设置
app.setUserTasks([
  {
    program: process.execPath,
    arguments: "--new-window",
    iconPath: process.execPath,
    iconIndex: 0,
    title: "新窗口",
    description: "创建一个新窗口",
  },
]);


