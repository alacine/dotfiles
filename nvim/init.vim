set clipboard=unnamed
set clipboard+=unnamedplus
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:python3_host_prog = '/usr/bin/python'
let g:python_host_prog = '/usr/bin/python2'
set cc=80

autocmd BufWritePost $MYVIMRC source $MYVIMRC
syntax enable
syntax on
"command! MakeTags !ctags -R .
set termguicolors
let mapleader=","
set path+=**
set wildmenu
set number
set relativenumber
set ts=4
set softtabstop=4
set shiftwidth=4
" set cindent
set smartindent
set expandtab
" 当前行高亮
set cursorline
" 当前列高亮
set cursorcolumn
set laststatus=2
set t_Co=256
set ignorecase
set scrolloff=5
"set foldmethod=indent
set foldmethod=syntax
set nofoldenable
"set undofile=~/.vim/undodir
set encoding=UTF-8
" 色彩问题 (注意: 这里的^[是按下C-v再按Esc得到的)
if has("termguicolors")
    " fix bug for vim
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum

    " enable true color
    set termguicolors
endif

autocmd BufRead,BufNewFile *.vue setlocal ts=2 sw=2 expandtab
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sw=2 sts=0 expandtab

inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {}<LEFT>
inoremap vv <Esc>`^

noremap <leader>w :w<cr>
noremap <leader>q :q<cr>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <leader>n :bn<cr>
noremap <leader>p :bp<cr>
noremap <leader>d :bd<cr>

noremap <space>v :e ~/.config/nvim/init.vim<cr>

" sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" use template python code
autocmd BufNewFile *_leetcode.py 0r ~/.vim/template/leetcode.py

" --------------------------------------------------------------------------------
set nocompatible              " be iMproved, required
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'flazz/vim-colorschemes'
Plug 'sainnhe/edge'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'airblade/vim-gitgutter'
Plug 'iamcco/mathjax-support-for-mkdp', { 'for': 'markdown' }
Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
Plug 'Yggdroot/indentLine', { 'for': ['python', 'c', 'cpp', 'go'] }
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'lfv89/vim-interestingwords'
Plug 'terryma/vim-multiple-cursors'
Plug 'godlygeek/tabular'
"Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'Chiel92/vim-autoformat'
Plug 'brooth/far.vim'
Plug 'jpalardy/vim-slime'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'mattn/emmet-vim', { 'for': ['html', 'vue'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'vue'] }
Plug 'mbbill/undotree'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'itchyny/vim-cursorword'
Plug 'chrisbra/csv.vim'
Plug 'junegunn/gv.vim'
Plug 'easymotion/vim-easymotion'
Plug 'liuchengxu/vista.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/suda.vim'
Plug 'honza/vim-snippets'
Plug 'voldikss/vim-floaterm'
Plug 'ripxorip/aerojump.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'jiangmiao/auto-pairs'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-yank', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
Plug 'voldikss/coc-floaterm', {'do': 'yarn install --frozen-lockfile'}
Plug 'weirongxu/coc-explorer', {'do': 'yarn install --frozen-lockfile'}
Plug 'fannheyward/coc-sql', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-java', {'do': 'yarn install --frozen-lockfile'}
call plug#end()
"--------------------------------------------------------------------------------

" edge
set background=dark
"let g:edge_style = 'default'
let g:edge_style = 'aura'
"let g:edge_style = 'neon'
let g:edge_disable_italic_comment = 1
colorscheme edge

" 背景半透明, 不是 edge 的配置但是需要放在 colorscheme 后面
"hi Normal guibg=NONE ctermbg=NONE

" indnetline
" 取消 indentline 在 markdown 和 latex 文件中的异常行为
let g:indentLine_concealcursor = ''
let g:indentLine_conceallevel = 1

" gitgutter
"let g:gitgutter_highlight_lines = 1

" vim-markdown
nnoremap <leader>tf :TableFormat<CR>

" lightline
set showtabline=2
let g:lightline = {
  \ 'colorscheme': 'edge',
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ }
let g:lightline.tabline = {
  \ 'left': [ [ 'buffers' ] ],
  \ 'right': [ [ 'close' ] ],
  \ }
let g:lightline.component_expand = { 'buffers': 'lightline#bufferline#buffers' }
let g:lightline.component_type   = { 'buffers': 'tabsel' }
autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
let g:lightline#bufferline#number_map = {
  \ '0': ' 0 ',
  \ '1': ' 1 ',
  \ '2': ' 2 ',
  \ '3': ' 3 ',
  \ '4': ' 4 ',
  \ '5': ' 5 ',
  \ '6': ' 6 ',
  \ '7': ' 7 ',
  \ '8': ' 8 ',
  \ '9': ' 9 ',
  \ }
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed = '[No Name]'
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" python-mode
"let g:pymode_python = 'python3'
"let g:pymode_motion = 1
"let pymode_lint_cwindow = 0
"let g:pymode_breakpoint_bind = '<leader>b'
"let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
"let g:pymode_lint = 0

" slime
let g:slime_target = 'tmux'
let g:slime_default_config = {'socket_name': 'default', 'target_pane': '{right-of}'}
let g:slime_python_ipython = 1

" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

" undotree
nnoremap <Leader>u :UndotreeToggle<CR>

" vim-session
let g:session_autosave = 'no'
let g:session_autoload = 'no'

" vim-session
map ss <Plug>(easymotion-s2)

" coc
source ~/.config/nvim/coc_example.vim

set ignorecase smartcase

" vim-go
let g:go_fmt_command = 'goimports'
let g:go_doc_keywordprg_enabled = 0
let g:go_template_autocreate = 0
let g:go_textobj_enabled = 0
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_structs = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 0
let g:go_highlight_variable_declarations = 0

" vista
let g:vista_sidebar_width = 40
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_py_executive = 'coc'
"let g:vista#renderer#ctags = 'vista_kind'
noremap <leader>V :Vista<space>

" fzf
au FileType fzf tnoremap <buffer> <C-j> <Down>
au FileType fzf tnoremap <buffer> <C-k> <Up>
noremap <space>f :Files<cr>
noremap <space>A :Ag<cr>
noremap <space>B :Buffers<cr>
noremap <space>C :Commands<cr>
noremap <space>L :Lines<cr>
noremap <space>l :BLines<cr>
" set preview window
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)
" set floating window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

" suda
if has("nvim")
    cnoremap w!! w suda://%
end

" floaterm
noremap <leader>fn :FloatermNew<space>
noremap <leader>r :FloatermNew ranger<cr>
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F10>'
autocmd User Startified setlocal buflisted

" aerojump
nmap <Leader>as <Plug>(AerojumpSpace)
nmap <Leader>ab <Plug>(AerojumpBolt)
nmap <Leader>aa <Plug>(AerojumpFromCursorBolt)
nmap <Leader>ad <Plug>(AerojumpDefault) " Boring mode
