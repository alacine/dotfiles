# Voxtype 离线语音输入

GUI 包列表安装 `voxtype-bin`、`wtype`、`pipewire-alsa`、`gtk4-layer-shell` 和 `ollama-cuda`。
Stow 配置使用本地 Whisper `large-v3-turbo` 模型、自动检测语言，并用本地 Qwen 模型将口语整理成书面语后输入当前文本框。

配置由仓库中的 `userhome/.config/voxtype/config.toml` 通过 Stow 管理。部署配置后运行一次初始化：

```sh
make deploy
make setup-voxtype
sudo systemctl enable --now ollama.service
ollama pull qwen3:4b-instruct-2507-q4_K_M
systemctl --user restart voxtype.service
```

`setup-voxtype` 下载模型、选择 GPU 后端，并启用用户服务。下载模型时需要联网，之后的语音识别在本地进行。用户服务设置了 `VOXTYPE_VULKAN_DEVICE=nvidia`，确保这台 AMD 核显与 NVIDIA 独显的笔记本使用独显。可在桌面会话中用 `voxtype info accel` 查看实际使用的后端。

`clean-transcript.py` 将转写文本发送给本机 Ollama 整理，超时或模型不可用时 Voxtype 会使用原始转写。可先用以下命令单独测试整理效果：

```sh
printf '%s\n' '我觉得吧，那个方案可能还是得再改改。' | python3 ~/.config/voxtype/clean-transcript.py
```

Hyprland 和 Niri 都使用 **Super+Alt+V**，Waybar 也有麦克风按钮：按或点击一次开始录音，再按或点击一次结束并转写到当前文本框。按钮会显示待机、录音、转写和服务停止状态。快捷键由窗口管理器处理，因此配置中关闭了 Voxtype 自身的 evdev 快捷键，无需加入 `input` 用户组。

也可以直接运行 `voxtype record start`，说话后运行 `voxtype record stop` 测试。`voxtype setup check` 可检查音频和文字输出依赖。
