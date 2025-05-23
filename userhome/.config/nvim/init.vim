set clipboard=unnamed
set clipboard+=unnamedplus
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:python3_host_prog = '/usr/bin/python'
let g:python_host_prog = '/usr/bin/python'
set cc=80

"autocmd BufWritePost $MYVIMRC source $MYVIMRC
syntax enable
syntax on
"command! MakeTags !ctags -R .
set termguicolors
let mapleader=","
set path+=**
set wildmenu
set mouse=
set number
"set relativenumber
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
"set scrolloff=5
"set foldmethod=indent
"set foldmethod=syntax
"set nofoldenable
set ignorecase smartcase
"set undofile=~/.vim/undodir
set encoding=UTF-8
set noautochdir
set autowrite
" 色彩问题 (注意: 这里的^[是按下C-v再按Esc得到的)
if has("termguicolors")
    " fix bug for vim
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum

    " enable true color
    set termguicolors
endif

autocmd BufNewFile,BufRead Jenkinsfile,Jenkinsfile*,*.Jenkinsfile setf groovy
autocmd BufRead,BufNewFile *.vue setlocal ts=2 sw=2 expandtab
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype yaml setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sw=2 sts=0 expandtab

"inoremap vv <Esc>`^
inoremap <C-l> <Esc>`^
noremap <leader>w :w<cr>
noremap <leader>q :q<cr>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <leader>n :bn<cr>
noremap <leader>N :bp<cr>
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
Plug 'navarasu/onedark.nvim'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'airblade/vim-gitgutter'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install', 'for': 'markdown' }
Plug 'Yggdroot/indentLine', { 'for': ['python', 'c', 'cpp', 'go'] }
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdcommenter'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'lfv89/vim-interestingwords'
Plug 'mg979/vim-visual-multi'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'Chiel92/vim-autoformat'
Plug 'brooth/far.vim'
Plug 'jpalardy/vim-slime'
Plug 'fatih/vim-go', { 'for': ['go'] ,'do': ':GoInstallBinaries' }
Plug 'buoto/gotests-vim', { 'for': 'go' }
Plug 'mattn/emmet-vim', { 'for': ['html', 'vue', 'markdown'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'vue'] }
Plug 'jvirtanen/vim-hcl'
Plug 'mbbill/undotree'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'itchyny/vim-cursorword'
Plug 'chrisbra/csv.vim'
Plug 'junegunn/gv.vim'
Plug 'easymotion/vim-easymotion'
Plug 'liuchengxu/vista.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/suda.vim'
Plug 'honza/vim-snippets'
Plug 'voldikss/vim-floaterm'
Plug 'voldikss/fzf-floaterm'
Plug 'ripxorip/aerojump.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'jiangmiao/auto-pairs'
Plug 'gcmt/wildfire.vim'
Plug 'matze/vim-move'
Plug 'APZelos/blamer.nvim'
Plug 'kshenoy/vim-signature'
Plug 'ryanoasis/vim-devicons'
Plug 'lervag/vimtex'
Plug 'arcticicestudio/nord-vim'
Plug 'rakr/vim-two-firewatch'
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'
Plug 'cappyzawa/starlark.vim'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'vmware/differential-datalog', {'rtp': 'tools/vim'}
Plug 'christoomey/vim-tmux-navigator'
Plug 'jbyuki/venn.nvim'
Plug 'hashivim/vim-terraform'
Plug 'folke/snacks.nvim'
Plug 'ledger/vim-ledger', { 'for': ['ledger'] }
"Plug 'puremourning/vimspector'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()
"--------------------------------------------------------------------------------

" coc
let g:coc_global_extensions = [
            \ 'coc-vimlsp',
            \ 'coc-actions',
            \ 'coc-diagnostic',
            \ 'coc-prettier',
            \ 'coc-syntax',
            \ 'coc-lists',
            \ 'coc-pyright',
            \ 'coc-java',
            \ 'coc-sumneko-lua',
            \ 'coc-html',
            \ 'coc-tsserver',
            \ 'coc-css',
            \ 'coc-vetur',
            \ 'coc-json',
            \ 'coc-yaml',
            \ 'coc-xml',
            \ 'coc-protobuf',
            \ 'coc-yank',
            \ 'coc-snippets',
            \ 'coc-todolist',
            \ 'coc-translator',
            \ 'coc-explorer',
            \ 'coc-gitignore']
source ~/.config/nvim/coc_example.vim
source ~/.config/nvim/coc_custom.vim

" onedark
let g:onedark_config = { 'style': 'darker' }
colorscheme onedark
"colorscheme nord

" 背景半透明, 需要放在 colorscheme 后面
"hi Normal guibg=NONE ctermbg=NONE

" indnetline
" 取消 indentline 在 markdown 和 latex 文件中的异常行为
let g:indentLine_concealcursor = ''
let g:indentLine_conceallevel = 1

" gitgutter
let g:gitgutter_highlight_lines = 1

" lightline
set showtabline=2
let g:lightline = {
  \ 'colorscheme': 'one',
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
let g:lightline#bufferline#enable_devicons = 1
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

" vim-markdown
let g:vim_markdown_folding_disabled = 1
" 默认的 ]c 与 gitgutter 的冲突
nmap ]h <Plug>Markdown_MoveToCurHeader

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

" vim-go
"let g:go_debug=['lsp']
"let g:go_debug=['shell-command']
"let g:go_fmt_command = 'goimports'
"let g:go_fmt_fail_silently = 0
let g:go_textobj_include_function_doc = 1
let g:go_doc_keywordprg_enabled = 0
let g:go_template_autocreate = 0
let g:go_textobj_enabled = 1
"let g:go_addtags_transform = "snake_case"
let g:go_addtags_transform = "camelcase"
" 这里有关 metalinter 一系列的使用
" github wiki 中的 Tutorial 写的有问题，注意看 :help vim-go 中的内容
let g:go_metalinter_autosave = 0
let g:go_metalinter_deadline = "5s"
let g:go_metalinter_command = 'golangci-lint'
"let g:go_metalinter_enabled = ['golangci-lint']
"let g:go_metalinter_autosave_enabled = ['errcheck', 'vet', 'revive']
let g:go_decls_includes = "func,type"
let g:go_auto_sameids = 0
let g:go_rename_command = 'gopls'
let g:go_play_open_browser = 1
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
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
noremap <leader>c :GoMetaLinter<cr>

" vista
let g:vista_sidebar_width = 40
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_py_executive = 'coc'
"let g:vista#renderer#ctags = 'vista_kind'
noremap <leader>vt :Vista<Cr>

" fzf
au FileType fzf tnoremap <buffer> <C-j> <Down>
au FileType fzf tnoremap <buffer> <C-k> <Up>
noremap <space>f :Files<cr>
noremap <space>g :Ag<cr>
" do not match file name when use Ag
command! -bang -nargs=* Agg call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
noremap <space>G :Agg<cr>
noremap <space>w :Ag <C-R><C-W><cr>
noremap <space>b :Buffers<cr>
noremap <space>C :Commands<cr>
noremap <space>L :Lines<cr>
noremap <space>l :BLines<cr>
" set preview window
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)
" set floating window
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

"command! FZFLib call fzf#run({'source': 'find $GOPATH/pkg/mod /usr/lib/go/src -type f'})
au FileType go command! -bang ProjectFiles call fzf#vim#files('$GOPATH/pkg/mod', <bang>0)
au FileType go command! -bang StdLibFiles call fzf#vim#files('/usr/lib/go/src', <bang>0)
noremap <space>F :ProjectFiles<cr>
noremap <space>S :StdLibFiles<cr>

" suda
if has("nvim")
    cnoremap w!! w suda://%
end

" floaterm
noremap <leader>ff :Floaterm
noremap <leader>fh :FloatermHide<cr>
noremap <leader>fn :FloatermNew<cr>
noremap <leader>fy :FloatermNew yazi<cr>
noremap <leader>fl :FloatermNew lazygit<cr>
let g:floaterm_autoclose = 1
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F10>'
autocmd User Startified setlocal buflisted

" fzf-floaterm
noremap <leader>t :Floaterms<cr>

" aerojump
nmap <Leader>as <Plug>(AerojumpSpace)
nmap <Leader>ab <Plug>(AerojumpBolt)
nmap <Leader>aa <Plug>(AerojumpFromCursorBolt)
nmap <Leader>ad <Plug>(AerojumpDefault) " Boring mode

" auto-pairs
let g:AutoPairsCenterLine = 0

" vim-codefmt
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  "autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
  "autocmd FileType dart AutoFormatBuffer dartfmt
  "autocmd FileType go AutoFormatBuffer gofmt
  "autocmd FileType gn AutoFormatBuffer gn
  "autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  "autocmd FileType java AutoFormatBuffer google-java-format
  "autocmd FileType python AutoFormatBuffer yapf
   "Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  "autocmd FileType vue AutoFormatBuffer prettier
augroup END

" venn
"set virtualedit=all
