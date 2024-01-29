// This is the preload script for Electron.
// It runs in the renderer process before the page is loaded.
// --------------------------------------------

// import { contextBridge } from 'electron'

// process.once('loaded', () => {
//   - Exposed variables will be accessible at "window.versions".
//   contextBridge.exposeInMainWorld('versions', process.env)
// })
import { contextBridge, ipcRenderer } from "electron";

process.once("loaded", () => {
  // 主题模块
  contextBridge.exposeInMainWorld("darkMode", {
    toggle: (theme: "system" | "light" | "dark") => ipcRenderer.invoke("dark-mode:toggle", theme),
    system: () => ipcRenderer.invoke("dark-mode:system"),
    light: () => ipcRenderer.invoke("dark-mode:light"),
    dark: () => ipcRenderer.invoke("dark-mode:dark"),
    isDark: () => ipcRenderer.invoke("dark-mode:isDark"),
  });

  contextBridge.exposeInMainWorld("windowToggle", {
    toggle: (type: "max" | "min" | "close") => {
      ipcRenderer.invoke("window-toggle", type);
    },
  });
});
