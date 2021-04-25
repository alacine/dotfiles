## plasma 桌面配置

> 安装主题, 图标, 窗口样式什么的, 为方便管理, 优先级 Arch 的源 > plasma-discover > ocs-url(store.kde.org, opendesktop.org) > 手动

* Theme
    - [McMojave](https://store.kde.org/p/1305006/)
    - [Sweet](https://store.kde.org/p/1294174/)
    - [canta-dark](https://store.kde.org/p/1220749/)

* Icon
    - McMojave-circle
    - Numix
    - candy-icons

* Font
    - ttf-monaco

* Widgets
    - ~~Active Window Control~~
    - Application title
    - Global Menu
    - Active bar
    - Pager Swith between virtual desktop
    - Color Picker
    - System tray
    - Digital Clock
    - Folder View
    - ~~Netspeed Widget~~

* Login Screen(SDDM)
    - [kde-plasma-chili](https://github.com/MarianArlt/kde-plasma-chili)
    - [sddm-sugar-dark](https://github.com/MarianArlt/sddm-sugar-dark)

### Window Decorations

* BreezemiteForman

### Terminal

* Konsole
    - Theme -> Breeze, One Dark

* [st](https://github.com/alacine/st)

### 下拉式终端 Yakuake

* Theme -> [Sierra Breeze Mini](https://store.kde.org/p/1256788/)

使用该主题时, 会导致 Configuration 按钮消失, 使用快捷键`Ctrl+Shift+,`即可, 或参考评论区回答`sed -i '/Skin=.*/d' ~/.config/yakuakerc && killall yakuake && yakuake &`

### plasma 中使用 i3wm

创建 `~/.config/plasma-workspace/env/set_window_manager.sh`, 并添加可执行权限

```
export KDEWM=/usr/bin/i3
```

### 屏幕录制闪屏问题

[[已解决]屏幕录制闪屏问题请教](https://bbs.archlinuxcn.org/viewtopic.php?id=5713)

System Settings > Display and Monitor > Compositor > Tearing prevention: (Never)

### 网易云音乐 kde 系统托盘右键无效问题

[[已解决]网易云音乐更新到1.1.3以后kde下托盘右键失效问题](https://bbs.archlinuxcn.org/viewtopic.php?id=5691)

在`netease-cloud-music.desktop`中修改启动命令为`env XDG_CURRENT_DESKTOP=DDE netease-cloud-music %U`
