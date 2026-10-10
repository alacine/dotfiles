def --env append-path [path: string] {
  let expanded = ($path | path expand)

  if not ($expanded in $env.PATH) {
    $env.PATH = ($env.PATH | append $expanded)
  }
}

$env.config.show_banner = false
$env.config.history.path = $nu.data-dir

let proxy_bypass = "127.0.0.1,::1,localhost,local,.local,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.cn"
$env.no_proxy = $proxy_bypass
$env.NO_PROXY = $proxy_bypass

$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"
$env.LC_CTYPE = "en_US.UTF-8"

$env.LIB_PATH = $"($env.HOME)/Lib"

$env.NODE_PATH = $"($env.LIB_PATH)/npm/lib/node_modules"
append-path $"($env.LIB_PATH)/npm/bin"

$env.GOPATH = $"($env.LIB_PATH)/Golang"
append-path $"($env.GOPATH)/bin"

$env.CARGO_HOME = $"($env.LIB_PATH)/cargo"
append-path $"($env.CARGO_HOME)/bin"

append-path $"($env.HOME)/.local/bin"

$env.PACKER_PLUGIN_PATH = $"($env.HOME)/.local/share/packer/plugins"
$env.EDITOR = "nvim"
$env.DISABLE_AUTO_TITLE = "true"
$env.LIBVIRT_DEFAULT_URI = "qemu:///system"

$env.FZF_DEFAULT_OPTS = "--height 40% --layout=reverse"
$env.FZF_CTRL_T_OPTS = "
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
$env.FZF_ALT_C_OPTS = "
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force
