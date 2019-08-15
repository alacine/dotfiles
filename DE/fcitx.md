## fcitx 输入法的配置

在 `/etc/profile` 中添加
```
# fcitx
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
```

在 `~/.xprofile` 中添加

```
#fcitx
export GTK_IM_MODULE=fcitx 
export QT_IM_MODULE=fcitx 
export XMODIFIERS="@im=fcitx"

export SAL_USE_VCLPLUGIN=gtk fcitx
```

## 搜狗输入法占用过高

Fcitx Configuration > Addon Config > Show Advance option > module > uncheck 'Sogou Cloud Pinyin'
