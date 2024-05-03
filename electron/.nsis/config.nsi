; 该脚本使用 HM VNISEdit 脚本编辑器向导产生

; 安装程序初始定义常量
!define PRODUCT_NAME "JiwuChat"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "Kiwi2333"
!define PRODUCT_WEB_SITE "https://jiwu.kiwi2333.top"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\极物圈.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; 欢迎页面
!insertmacro MUI_PAGE_WELCOME
; 许可协议页面
!insertmacro MUI_PAGE_LICENSE "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\YourSoftwareLicence.txt"
; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!define MUI_FINISHPAGE_RUN "$INSTDIR\极物圈.exe"
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "JiwuChat Setup.exe"
InstallDir "$PROGRAMFILES\JiwuChat"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\极物圈.exe"
  CreateDirectory "$SMPROGRAMS\JiwuChat"
  CreateShortCut "$SMPROGRAMS\JiwuChat\JiwuChat.lnk" "$INSTDIR\极物圈.exe"
  CreateShortCut "$DESKTOP\JiwuChat.lnk" "$INSTDIR\极物圈.exe"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\chrome_100_percent.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\chrome_200_percent.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\d3dcompiler_47.dll"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\ffmpeg.dll"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\icudtl.dat"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\libEGL.dll"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\libGLESv2.dll"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\LICENSE.electron.txt"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\LICENSES.chromium.html"
  SetOutPath "$INSTDIR\locales"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\af.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\am.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\ar.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\bg.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\bn.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\ca.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\cs.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\da.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\de.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\el.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\en-GB.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\en-US.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\es-419.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\es.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\et.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\fa.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\fi.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\fil.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\fr.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\gu.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\he.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\hi.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\hr.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\hu.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\id.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\it.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\ja.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\kn.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\ko.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\lt.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\lv.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\ml.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\mr.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\ms.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\nb.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\nl.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\pl.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\pt-BR.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\pt-PT.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\ro.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\ru.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\sk.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\sl.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\sr.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\sv.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\sw.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\ta.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\te.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\th.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\tr.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\uk.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\ur.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\vi.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\zh-CN.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\locales\zh-TW.pak"
  SetOutPath "$INSTDIR\resources"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\resources\app-update.yml"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\resources\app.asar"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\resources\elevate.exe"
  SetOutPath "$INSTDIR"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\resources.pak"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\snapshot_blob.bin"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\v8_context_snapshot.bin"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\vk_swiftshader.dll"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\vk_swiftshader_icd.json"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\vulkan-1.dll"
  File "E:\Coding Life\Project\jiwu-mall-project\jiwu-mall-chat-electron\electron-dist\win-unpacked\极物圈.exe"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\JiwuChat\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\JiwuChat\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\极物圈.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\极物圈.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\极物圈.exe"
  Delete "$INSTDIR\vulkan-1.dll"
  Delete "$INSTDIR\vk_swiftshader_icd.json"
  Delete "$INSTDIR\vk_swiftshader.dll"
  Delete "$INSTDIR\v8_context_snapshot.bin"
  Delete "$INSTDIR\snapshot_blob.bin"
  Delete "$INSTDIR\resources.pak"
  Delete "$INSTDIR\resources\elevate.exe"
  Delete "$INSTDIR\resources\app.asar"
  Delete "$INSTDIR\resources\app-update.yml"
  Delete "$INSTDIR\locales\zh-TW.pak"
  Delete "$INSTDIR\locales\zh-CN.pak"
  Delete "$INSTDIR\locales\vi.pak"
  Delete "$INSTDIR\locales\ur.pak"
  Delete "$INSTDIR\locales\uk.pak"
  Delete "$INSTDIR\locales\tr.pak"
  Delete "$INSTDIR\locales\th.pak"
  Delete "$INSTDIR\locales\te.pak"
  Delete "$INSTDIR\locales\ta.pak"
  Delete "$INSTDIR\locales\sw.pak"
  Delete "$INSTDIR\locales\sv.pak"
  Delete "$INSTDIR\locales\sr.pak"
  Delete "$INSTDIR\locales\sl.pak"
  Delete "$INSTDIR\locales\sk.pak"
  Delete "$INSTDIR\locales\ru.pak"
  Delete "$INSTDIR\locales\ro.pak"
  Delete "$INSTDIR\locales\pt-PT.pak"
  Delete "$INSTDIR\locales\pt-BR.pak"
  Delete "$INSTDIR\locales\pl.pak"
  Delete "$INSTDIR\locales\nl.pak"
  Delete "$INSTDIR\locales\nb.pak"
  Delete "$INSTDIR\locales\ms.pak"
  Delete "$INSTDIR\locales\mr.pak"
  Delete "$INSTDIR\locales\ml.pak"
  Delete "$INSTDIR\locales\lv.pak"
  Delete "$INSTDIR\locales\lt.pak"
  Delete "$INSTDIR\locales\ko.pak"
  Delete "$INSTDIR\locales\kn.pak"
  Delete "$INSTDIR\locales\ja.pak"
  Delete "$INSTDIR\locales\it.pak"
  Delete "$INSTDIR\locales\id.pak"
  Delete "$INSTDIR\locales\hu.pak"
  Delete "$INSTDIR\locales\hr.pak"
  Delete "$INSTDIR\locales\hi.pak"
  Delete "$INSTDIR\locales\he.pak"
  Delete "$INSTDIR\locales\gu.pak"
  Delete "$INSTDIR\locales\fr.pak"
  Delete "$INSTDIR\locales\fil.pak"
  Delete "$INSTDIR\locales\fi.pak"
  Delete "$INSTDIR\locales\fa.pak"
  Delete "$INSTDIR\locales\et.pak"
  Delete "$INSTDIR\locales\es.pak"
  Delete "$INSTDIR\locales\es-419.pak"
  Delete "$INSTDIR\locales\en-US.pak"
  Delete "$INSTDIR\locales\en-GB.pak"
  Delete "$INSTDIR\locales\el.pak"
  Delete "$INSTDIR\locales\de.pak"
  Delete "$INSTDIR\locales\da.pak"
  Delete "$INSTDIR\locales\cs.pak"
  Delete "$INSTDIR\locales\ca.pak"
  Delete "$INSTDIR\locales\bn.pak"
  Delete "$INSTDIR\locales\bg.pak"
  Delete "$INSTDIR\locales\ar.pak"
  Delete "$INSTDIR\locales\am.pak"
  Delete "$INSTDIR\locales\af.pak"
  Delete "$INSTDIR\LICENSES.chromium.html"
  Delete "$INSTDIR\LICENSE.electron.txt"
  Delete "$INSTDIR\libGLESv2.dll"
  Delete "$INSTDIR\libEGL.dll"
  Delete "$INSTDIR\icudtl.dat"
  Delete "$INSTDIR\ffmpeg.dll"
  Delete "$INSTDIR\d3dcompiler_47.dll"
  Delete "$INSTDIR\chrome_200_percent.pak"
  Delete "$INSTDIR\chrome_100_percent.pak"
  Delete "$INSTDIR\极物圈.exe"

  Delete "$SMPROGRAMS\JiwuChat\Uninstall.lnk"
  Delete "$SMPROGRAMS\JiwuChat\Website.lnk"
  Delete "$DESKTOP\JiwuChat.lnk"
  Delete "$SMPROGRAMS\JiwuChat\JiwuChat.lnk"

  RMDir "$SMPROGRAMS\JiwuChat"
  RMDir "$INSTDIR\resources"
  RMDir "$INSTDIR\locales"

  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确定要完全卸载极物圈吗？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
FunctionEnd
