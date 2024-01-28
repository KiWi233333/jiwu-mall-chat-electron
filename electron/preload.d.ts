export interface DarkModeElectron {
  toggle: (theme: "system" | "light" | "dark") => Promise<boolean>
  system: () => Promise<boolean>
  isDark: () => Promise<boolean>
}

declare global {
  interface Window {
    darkMode: DarkModeElectron
  }
}
