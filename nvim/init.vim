set clipboard=unnamed
set clipboard+=unnamedplus
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:python3_host_prog = '/usr/bin/python'
let g:python_host_prog = '/usr/bin/python2'

autocmd BufWritePost $MYVIMRC source $MYVIMRC
syntax enable
syntax on
"command! MakeTags !ctags -R .
" set termguicolors
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
"set undofile=~/.vim/undodir

" 色彩问题 (注意: 这里的^[是按下C-v再按Esc得到的)
if has("termguicolors")
    " fix bug for vim
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum

    " enable true color
    set termguicolors
endif

inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {}<LEFT>
inoremap vv <Esc>`^

noremap <leader>w :w<cr>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <leader>n :bn<cr>
noremap <leader>p :bp<cr>
noremap <leader>d :bd<cr>

nnoremap <leader>f :TableFormat<CR>
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> [n :bnext<CR>

" sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" use template python code
autocmd BufNewFile *_leetcode.py 0r ~/.vim/template/leetcode.py

" --------------------------------------------------------------------------------
set nocompatible              " be iMproved, required
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'rakr/vim-one'
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'zgpio/tree.nvim'
Plug 'airblade/vim-gitgutter'
Plug 'flazz/vim-colorschemes'
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
Plug 'Yggdroot/indentLine', { 'for': ['python', 'c', 'cpp', 'go'] }
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'majutsushi/tagbar'
Plug 'lfv89/vim-interestingwords'
Plug 'rking/ag.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'godlygeek/tabular'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'w0rp/ale'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'Chiel92/vim-autoformat'
Plug 'mileszs/ack.vim'
Plug 'brooth/far.vim'
Plug 'jpalardy/vim-slime'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'mbbill/undotree'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'itchyny/vim-cursorword'
Plug 'chrisbra/csv.vim'
Plug 'junegunn/gv.vim'
Plug 'easymotion/vim-easymotion'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vista.vim'
call plug#end()
"--------------------------------------------------------------------------------

" ----------vim-one-----------
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif
set background=dark " for the dark version
" set background=light " for the light version
let g:one_allow_italics = 1
" 解决 one 主题背景色异常问题
au ColorScheme one hi Normal ctermbg=None
colorscheme one
let g:airline_theme='one'

" ----------hybrid-----------
"set background=dark
"let g:hybrid_custom_term_colors=1
"let g:hybrid_reduced_contrast=1
"colorscheme hybrid_reverse
"colorscheme hybrid
"au ColorScheme hybrid hi Normal ctermbg=None
"au ColorScheme hybrid_reverse hi Normal ctermbg=None
"if (has("nvim"))
  "let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"endif
"if (has("termguicolors"))
  "set termguicolors
"endif
"set background=dark
"colorscheme hybrid_reverse
"let g:enable_italic_font = 1
"let g:airline_theme = 'hybrid'
"let g:hybrid_transparent_background = 1

" --------indnetline---------
" 取消 indentline 在 markdown 和 latex 文件中的异常行为
let g:indentLine_concealcursor = ''
let g:indentLine_conceallevel = 1

" ----------NERDTree-----------
" 启动 vim 时自动打开 NERDTree
" autocmd vimenter * NERDTree
" 自动退出
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map ,g :NERDTreeToggle<CR>
map ,v :NERDTreeFind<CR>
map ,x :GitGutterLineHighlightsToggle<CR>
let NERDTreeShowHidden=1
let g:NERDTreeShowIgnoredStatus = 1
let NERDTreeShowLineNumbers=1
let NERDTreeAutoCenter=1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
set updatetime=100

" ----------gitgutter-----------
let g:gitgutter_highlight_lines = 1

" ----------tagbar-----------
map ,t :TagbarToggle<CR>

" ---------airline----------
let g:airline#extensions#tabline#enabled = 1

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
"let g:airline_theme = 'hybridline'

" -------python-mode---------
"let g:pymode_python = 'python3'
let g:pymode_motion = 1
let pymode_lint_cwindow = 0
let g:pymode_breakpoint_bind = '<leader>b'
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
"let g:pymode_lint = 0

" ---------slime----------
let g:slime_target = 'tmux'
let g:slime_default_config = {'socket_name': 'default', 'target_pane': '{right-of}'}
let g:slime_python_ipython = 1

" ---------ale------------
let g:ale_python_pylint_options = '--load-plugins pylint_django'
let g:ale_python_pylint_options = '--extension-pkg-whitelist=cv2'
let g:ale_linters = {
    \ 'python': ['pyflakes', 'pep8', 'mccabe'],
    \ 'go': ['gopls']
\ }
let g:ale_set_highlights = 0
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
let g:ale_open_list = 0

" --------vim-javascript--------
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

" ---------undotree---------
nnoremap <Leader>u :UndotreeToggle<CR>

" ----------vim-session----------------
let g:session_autosave = 'no'
let g:session_autoload = 'no'

" ----------vim-session----------------
map ss <Plug>(easymotion-s2)

" ----------coc----------------
source ~/.config/nvim/coc_example.vim

" ---------tree.nvim------
"nnoremap <silent> <Space>z :<C-u>Tree -columns=mark:git:indent:icon:filename:size \ -split=vertical
      "\ -direction=topleft
      "\ -winwidth=40
      "\ -listed
      "\ `expand('%:p:h')`<CR>

"call tree#custom#option('_', {
      "\ 'root_marker': '',
      "\ })

"autocmd FileType tree call s:set_tree()
"func! s:set_tree() abort
    "nnoremap <silent><buffer><expr> > tree#action('toggle_ignored_files')
    "nnoremap <silent><buffer><expr> * tree#action('toggle_select_all')
    "nnoremap <silent><buffer><expr> s tree#action('drop', 'split')
    "nnoremap <silent><buffer><expr> <CR> tree#action('drop')
    "nnoremap <silent><buffer><expr> <Tab> tree#action('toggle_select') . 'j'
    "nnoremap <silent><buffer><expr> <C-l> tree#action('redraw')
    "nnoremap <silent><buffer><expr> <C-g> tree#action('print')
    "nnoremap <silent><buffer><expr> E tree#action('open', 'vsplit')
    "nnoremap <silent><buffer><expr> o tree#action('open_or_close_tree')
    "nnoremap <silent><buffer><expr> R tree#action('open_tree_recursive')
    "nnoremap <silent><buffer><expr> r tree#action('rename')
    "nnoremap <silent><buffer><expr> x tree#action('execute_system')
    "nnoremap <silent><buffer><expr> N tree#action('new_file')
    "nnoremap <silent><buffer><expr> h tree#action('cd', ['..'])
    "nnoremap <silent><buffer><expr> cd tree#action('cd', '.')
    "nnoremap <silent><buffer><expr> \ tree#action('cd', getcwd())
    "nnoremap <silent><buffer><expr> ~ tree#action('cd')
    "nnoremap <silent><buffer><expr> l tree#action('open')
    "nnoremap <silent><buffer><expr> yy tree#action('yank_path')
"endf

" ----------vim-go--------
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_def_mapping_enable = 0
