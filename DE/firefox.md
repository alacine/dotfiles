## Firefox

### Hardware video decoding

Do not manage `~/.mozilla` in this dotfiles repository. Firefox profile
directories contain generated IDs, for example:

```text
~/.mozilla/firefox/<random>.default/
~/.mozilla/firefox/<random>.default-release-<timestamp>/
```

These paths are machine-local and should not be committed. Configure hardware
video decoding manually on each machine.

Open `about:config` and set:

```text
media.ffmpeg.vaapi.enabled = true
media.hardware-video-decoding.force-enabled = true
media.rdd-ffmpeg.enabled = true
media.av1.enabled = false
gfx.x11-egl.force-enabled = true
```

For NVIDIA VA-API on Wayland, launch Firefox with:

```bash
MOZ_ENABLE_WAYLAND=1 LIBVA_DRIVER_NAME=nvidia NVD_BACKEND=direct MOZ_DISABLE_RDD_SANDBOX=1 firefox
```

If using a `.desktop` override, put the same environment variables before the
`firefox` command in each `Exec=` line.

Verify while a supported video is playing:

```bash
nvidia-smi dmon -s u
nvidia-smi pmon -c 1
```

Hardware decoding is active when the `dec` column is non-zero. On RTX 2060,
AV1 is not supported by NVDEC, so prefer VP9/H.264 when testing.
