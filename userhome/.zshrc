# Completion
autoload -Uz compinit
zmodload zsh/complist
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
setopt auto_menu complete_in_word always_to_end
unsetopt menu_complete flowcontrol

# Keep the existing history shared between sessions.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history hist_expire_dups_first hist_ignore_dups
setopt hist_ignore_space hist_verify share_history

# Interactive editing
setopt auto_cd auto_pushd pushd_ignore_dups pushdminus no_beep
WORDCHARS=''
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey ' ' magic-space

# Personal aliases
alias ls='ls --color=auto'
alias ll='ls -hl --color=auto'
alias vi='vim'
alias nvi='nvim'
alias emacs='emacs -nw'
alias ra='ranger'
alias lg='lazygit'
alias sc='systemctl'
alias kb='kubectl'
alias dc='docker compose'
alias tf='terraform'
alias sz='lrzsz-sz'
alias rz='lrzsz-rz'
alias gst='git status'
alias gf='git fetch'
alias gl='git pull'
alias gp='git push'
alias glra='git pull --rebase --autostash'
alias gcmsg='git commit -m'

export no_proxy=127.0.0.1,::1,localhost,local,.local,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.cn
export NO_PROXY=127.0.0.1,::1,localhost,local,.local,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.cn

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export LIB_PATH="$HOME/Lib"

# npm config set registry https://registry.npmmirror.com
# npm config set prefix '~/Lib/npm'
export NODE_PATH="$LIB_PATH/npm/lib/node_modules"
export PATH="$PATH:$LIB_PATH/npm/bin"

# go env -w GO111MODULE=on
# go env -w GOPROXY=https://goproxy.cn
export GOPATH="$LIB_PATH/Golang"
export PATH=$PATH:$GOPATH/bin

# cargo
export CARGO_HOME="$LIB_PATH/cargo"
export PATH="$CARGO_HOME/bin:$PATH"
if (( $+commands[brew] )); then
	rustup_prefix="$(brew --prefix rustup 2>/dev/null)"
	if [[ -n "$rustup_prefix" ]]; then
		export PATH="$rustup_prefix/bin:$PATH"
	fi
	unset rustup_prefix
fi

# pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
export PATH=$PATH:$HOME/.local/bin

# ruby
# (Intentionally do not export GEM_HOME or add gem bins to PATH globally.
# This avoids leaking user gems into makepkg/paru builds.)

# packer
export PACKER_PLUGIN_PATH="$HOME/.local/share/packer/plugins"

export EDITOR=nvim

# change default libvirt URI
export LIBVIRT_DEFAULT_URI="qemu:///system"

eval "$(zoxide init zsh)"

#export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse"
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# if [[ -n $TMUX ]]; then
#     __kdwithtmuxpopup() {
#         tmux display-popup "kd $@"
#     }
#     alias kd=__kdwithtmuxpopup
# fi

[[ ! -f "$HOME/.privaterc" ]] || source "$HOME/.privaterc"
[[ ! -f "$HOME/.workrc" ]] || source "$HOME/.workrc"

# Share the prompt configuration with Nushell.
eval "$(starship init zsh)"

source ${HOME}/.privaterc
source ${HOME}/.workrc
