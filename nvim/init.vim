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
Plug 'rakr/vim-one'
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'vwxyutarooo/nerdtree-devicons-syntax'
Plug 'airblade/vim-gitgutter'
Plug 'flazz/vim-colorschemes'
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown' }
Plug 'Yggdroot/indentLine', { 'for': ['python', 'c', 'cpp', 'go'] }
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'lfv89/vim-interestingwords'
"Plug 'rking/ag.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'godlygeek/tabular'
"Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
"Plug 'w0rp/ale'
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
Plug 'liuchengxu/vista.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/suda.vim'
Plug 'honza/vim-snippets'
Plug 'voldikss/vim-floaterm'

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
hi Normal guibg=NONE ctermbg=NONE

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

" ----nerdtree-devicons-syntax--
let s:colors = {
  \ 'brown'       : "905532",
  \ 'aqua'        : "3AFFDB",
  \ 'blue'        : "689FB6",
  \ 'darkBlue'    : "44788E",
  \ 'purple'      : "834F79",
  \ 'lightPurple' : "834F79",
  \ 'red'         : "AE403F",
  \ 'beige'       : "F5C06F",
  \ 'yellow'      : "F09F17",
  \ 'orange'      : "D4843E",
  \ 'darkOrange'  : "F16529",
  \ 'pink'        : "CB6F6F",
  \ 'salmon'      : "EE6E73",
  \ 'green'       : "8FAA54",
  \ 'lightGreen'  : "31B53E",
  \ 'white'       : "FFFFFF"
\ }

" ----------gitgutter-----------
"let g:gitgutter_highlight_lines = 1

" ----------vim-markdown--------
nnoremap <leader>tf :TableFormat<CR>

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
"let g:pymode_motion = 1
"let pymode_lint_cwindow = 0
"let g:pymode_breakpoint_bind = '<leader>b'
"let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
"let g:pymode_lint = 0

" ---------slime----------
let g:slime_target = 'tmux'
let g:slime_default_config = {'socket_name': 'default', 'target_pane': '{right-of}'}
let g:slime_python_ipython = 1

" ---------ale------------
"let g:ale_python_pylint_options = '--load-plugins pylint_django'
"let g:ale_python_pylint_options = '--extension-pkg-whitelist=cv2'
"let g:ale_linters = {
    "\ 'python': ['pyflakes', 'pep8', 'mccabe'],
    "\ 'go': ['gopls']
"\ }
"let g:ale_set_highlights = 0
"let g:ale_sign_error = '✗'
"let g:ale_sign_warning = '⚡'
"let g:ale_open_list = 0

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

set ignorecase smartcase

" ----------vim-go--------
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_def_mapping_enable = 0
let g:go_fmt_command = 'goimports'

" ----------vista---------
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

let g:vista_sidebar_width = 40
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_py_executive = 'coc'
"let g:vista#renderer#ctags = 'vista_kind'
noremap <leader>t :Vista<space>

" ----------range---------
let g:ranger_map_keys = 0
map <leader>r :Ranger<CR>

" ----------fzf---------
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
let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
au FileType fzf set nonu nornu

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = &lines - 8
  let width = float2nr(&columns - (&columns * 2 / 10))
  let col = float2nr((&columns - width) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': 4,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

" ----------suda---------
if has("nvim")
    cnoremap w!! w suda://%
end
