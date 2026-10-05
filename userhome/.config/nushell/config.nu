alias pbcopy = xclip -selection clipboard
alias pbpaste = xclip -selection clipboard -o
alias vi = vim
alias nvi = nvim
alias emacs = ^emacs -nw
alias ra = ranger
alias lg = lazygit
alias sc = systemctl
alias kb = kubectl
alias glra = git pull --rebase --autostash
alias dc = docker compose
alias tf = terraform
alias sz = lrzsz-sz
alias rz = lrzsz-rz

def --env yy [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX" | str trim)

  ^yazi ...$args --cwd-file $tmp

  let cwd = (open --raw $tmp | str trim)
  if ($cwd != "" and $cwd != $env.PWD) {
    cd $cwd
  }

  rm -f $tmp
}
