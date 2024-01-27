/* eslint-disable n/prefer-global/process */
import * as path from "node:path";
import * as os from "node:os";
import { BrowserWindow, app, session } from "electron";
import singleInstance from "./singleInstance";
import dynamicRenderer from "./dynamicRenderer";
import titleBarActionsModule from "./modules/titleBarActions";
import updaterModule from "./modules/updater";
import macMenuModule from "./modules/macMenu";

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
  console.log("系统信息：", { isPord, platform, architucture });
  // Create the browser window.
  const mainWindow = new BrowserWindow({
    title: "极物圈",
    width: 1244,
    height: 864,
    minWidth: 425,
    minHeight: 676,
    frame: false, // 无边框
    titleBarStyle: "hidden", // 隐藏标题栏
    // transparent: true, // 透明
    backgroundColor: "#fff",
    webPreferences: {
      devTools: !isPord,
      nodeIntegration: true,
      contextIsolation: false,
      preload: path.join(__dirname, "preload.js"),
    },
    // frame: platform === 'darwin',
    // titleBarOverlay: platform === 'darwin' && { height: headerSize },
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

  const mainWindow = createWindow();
  if (!mainWindow)
    return;

  // Load renderer process
  dynamicRenderer(mainWindow);

  // Initialize modules
  console.log(`${"-".repeat(30)}\n[+] Loading modules...`);
  modules.forEach((module) => {
    try {
      module(mainWindow);
    }
    catch (err: any) {
      console.log("[!] Module error: ", err.message || err);
    }
  });

  console.log("[!] Loading modules: Done." + `\r\n${"-".repeat(30)}`);

  app.on("activate", () => {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    // if (BrowserWindow.getAllWindows().length === 0) createWindow()
    mainWindow.show();
  });
});

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on("window-all-closed", () => {
  if (process.platform !== "darwin")
    app.quit();
});
