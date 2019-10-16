set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set clipboard+=unnamedplus
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:python3_host_prog = '/usr/bin/python'
