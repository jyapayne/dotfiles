

call plug#begin('~/.local/share/nvim/plugged')
Plug 'rust-lang/rust.vim'
Plug 'jyapayne/nim.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'hynek/vim-python-pep8-indent'
Plug 'pangloss/vim-javascript'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'tpope/vim-haml'
Plug 'hdima/python-syntax'
Plug 'hail2u/vim-css3-syntax'
Plug 'mxw/vim-jsx'
Plug 'ryanoasis/vim-devicons'
Plug 'johnstef99/vim-nerdtree-syntax-highlight'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'mustache/vim-mustache-handlebars'
Plug 'vim-scripts/errormarker.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'jreybert/vim-largefile'
Plug 'sbdchd/neoformat'
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'vim-syntastic/syntastic'
"Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'
Plug 'w0rp/ale'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'udalov/kotlin-vim'
Plug 'simnalamburt/vim-mundo'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-surround'
" Plug 'alaviss/nim.nvim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'tpope/vim-repeat'
Plug 'christoomey/vim-sort-motion'
Plug 'christoomey/vim-system-copy'
Plug 'michaeljsmith/vim-indent-object'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'Julian/vim-textobj-brace'
Plug 'bps/vim-textobj-python'
Plug 'wellle/targets.vim'
Plug 'svermeulen/vim-easyclip'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'rescript-lang/vim-rescript'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'kassio/neoterm'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'jyapayne/vim-code-dark'
" Plug 'jyapayne/vimspector'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'TimUntersberger/neogit'
Plug 'sindrets/diffview.nvim', {'branch': 'main'}
Plug 'lewis6991/gitsigns.nvim', {'branch': 'main'}
Plug 'peterhoeg/vim-qml'
Plug 'mfussenegger/nvim-dap'
" Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'mfussenegger/nvim-dap-python'
Plug 'KabbAmine/vCoolor.vim'
" Plug 'chrisbra/Colorizer'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'edluffy/hologram.nvim'
Plug 'hashivim/vim-terraform'
Plug 'fatih/vim-go'

"Plug 'baabelfish/nvim-nim'
call plug#end()

" map <ESC>[1;5A <C-Up>
" map <ESC>[1;5B <C-Down>
" map <ESC>[1;5C <C-Right>
" map <ESC>[1;5D <C-Left>
nnoremap gm m
nnoremap <Tab> <C-w>w
let g:ale_shell="/bin/bash"
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('/tmp/vim-lsp.log')

" Live updating substitution!
set inccommand=nosplit
let g:airline#extensions#ale#enabled = 1

let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

let g:syntastic_c_compiler_options = "-std=c99"
set guicursor=v-c-sm:block,n-i-ci-ve:ver25,r-cr-o:hor20

" inoremap vmark ✓

augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

set wildmenu
set wildmode=full
"set shell=bash
set smartindent
set ruler
set t_Co=256

set backspace=2
set autowrite

set smarttab

set expandtab
set nocompatible
set history=10000
set foldmethod=indent
set foldlevel=99
let g:pydiction_location='/home/joey/.vim/bundle/pydiction/complete-dict'
let g:jsx_ext_required = 0
let g:asyncrun_auto = "make"
let g:syntastic_enable_elixir_checker = 1
let g:syntastic_elixir_checkers = ['elixir']
let g:LargeFile = 20
"set  rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline_section_warning = ''
let g:airline_section_z = '%l/%L:%c'


set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=10000
set undoreload=10000        " number of lines to save for undo
filetype plugin indent on
set incsearch
set guicursor=

let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0

set mouse=a
set tabstop=4
set shiftwidth=4

"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_check_on_wq = 0
let g:python_highlight_space_errors = 0
let g:jsx_ext_required = 0
"let g:airline#extensions#tabline#enabled = 1

autocmd Filetype javascript setlocal ts=2 sw=2 expandtab

map <C-n> :NERDTreeTabsToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
autocmd Filetype nim setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype less setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype css setlocal ts=2 sts=2 sw=2 expandtab
let g:syntastic_javascript_checkers = ['eslint', 'flow']
let g:syntastic_java_checkers = []

let g:neoformat_javascript_prettier = {
    \ 'exe': 'prettier',
    \ 'args': ['--single-quote', '--trailing-comma all'],
    \ }

let g:toggleJSFormat = 0
function! ToggleJSFormat(...)
  if a:0 == 1 "toggle behaviour
    let g:toggleJSFormat = 1 - g:toggleJSFormat
  endif

  if g:toggleJSFormat == 0 "normal action, do the hi
    autocmd!
    autocmd BufWritePre *.js Neoformat
    autocmd BufWritePre *.jsx Neoformat
  else
    autocmd!
    autocmd BufWritePre *.js ""
    autocmd BufWritePre *.jsx ""
  endif
endfunction

map <F9> :call ToggleJSFormat(1)<CR>
"call ToggleJSFormat()

" autocmd BufNew * if winnr('$') == 1 | tabmove99 | endif

au! FileType python setl nosmartindent
au BufRead,BufNewFile *.py,*.js,*.jsx,*.nim,*.ml,*.mli match OverLength /\%89v.\+/
au BufRead,BufNewFile *.py,*.js,*.jsx,*.nim,*.ml,*.mli 2match ExtraWhiteSpace /\s\+$\|\t/
au StdinReadPost * set buftype=nofile
syntax on

command C let @/=""
command CC :%s#_\(\l\)#\u\1#g
command U :%s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g

map <Leader>y "*y
map <Leader>p "*p

nmap =j :%!python3 -m json.tool<CR>

if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  autocmd BufRead,BufNewFile,FileReadPost *.py source ~/.vim/python
endif
au BufRead,BufNewFile *.shpaml setfiletype shpaml

nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" This beauty remembers where you were the last time you edited the file, and returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
au BufRead,BufNewFile *.sass set filetype=sass

map <F3> :mksession! ~/.vim_session <cr>
map <F4> :source ~/.vim_session <cr>

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" make escape key not delay
set timeoutlen=1000 ttimeoutlen=0

" nmap <C-k> [e
" nmap <C-j> ]e
vmap <C-k> [egv
vmap <C-j> ]egv

vnoremap # :s#^#\##<cr>
vnoremap -# :s#^\###<cr>

fun! JumpToDef()
  if exists("*GotoDefinition_" . &filetype)
    call GotoDefinition_{&filetype}()
  else
    exe "norm! \<C-]>"
  endif
endf

" Jump to tag
" nn <C-g> :call JumpToDef()<cr>
" ino <C-g> <esc>:call JumpToDef()<cr>i

"nn <C-m> :Rg<cr>
nnoremap <leader>ff :Rg<CR>

autocmd FileType ocaml nmap <C-t> :MerlinTypeOf<cr>

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_of_chars_for_completion = 99
let g:flow#enable = 0

command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|node_modules|nimcache|\.sass-cache|bower_components|build|dist)$',
  \ 'file': '\v\.(exe|so|dll|o)$',
  \ 'link': '',
  \ }
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }


" noremap ˚ :tabr<cr>
" noremap ∆ :tabl<cr>
noremap ˙ gT
noremap ¬ gt

" inoremap ˚ <Esc>:tabr<cr>i
" inoremap ∆ <Esc>:tabl<cr>i
inoremap ˙ <Esc>gTi
inoremap ¬ <Esc>gti

set clipboard=
let g:EasyClipShareYanks = 1


"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_wq = 0


let g:gitsigns_head = "main"

" lewis6991/gitsigns.nvim
lua << EOF
 require('gitsigns').setup({
     \ word_diff = true
   \ })
EOF

" let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools', 'CodeLLDB' ]
" puremourning/vimspector
 " fun! GotoWindow(id)
 "   :call win_gotoid(a:id)
 " endfun
 " func! AddToWatch()
 "   let word = expand("<cexpr>")
 "   call vimspector#AddWatch(word)
 " endfunction
 " let g:vimspector_base_dir = expand('$HOME/.config/vimspector-config')
 " let g:vimspector_sidebar_width = 60
 " nnoremap <leader>da :call vimspector#Launch()<CR>
 " nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
 " nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
 " nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
 " nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
 " nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
 " nnoremap <leader>di :call AddToWatch()<CR>
 " nnoremap <leader>dx :call vimspector#Reset()<CR>
 " nnoremap <leader>dX :call vimspector#ClearBreakpoints()<CR>
 " nnoremap <S-k> :call vimspector#StepOut()<CR>
 " nnoremap <S-l> :call vimspector#StepInto()<CR>
 " nnoremap <S-j> :call vimspector#StepOver()<CR>
 " nnoremap <leader>d_ :call vimspector#Restart()<CR>
 " nnoremap <leader>dn :call vimspector#Continue()<CR>
 " nnoremap <leader>drc :call vimspector#RunToCursor()<CR>
 " nnoremap <leader>dh :call vimspector#ToggleBreakpoint()<CR>
 " nnoremap <leader>de :call vimspector#ToggleConditionalBreakpoint()<CR>
 " let g:vimspector_sign_priority = {
 "   \    'vimspectorBP':         998,
 "   \    'vimspectorBPCond':     997,
 "   \    'vimspectorBPDisabled': 996,
 "   \    'vimspectorPC':         999,
 "   \ }


let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors
lua require'colorizer'.setup()

nnoremap <F6> :MundoToggle<CR>
nnoremap riW ciW<C-r>0<ESC>
nnoremap riw ciw<C-r>0<ESC>
let g:EasyClipShareYanks = 1

"let base16colorspace=256
" set background=dark
"colorscheme base16-default-dark
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
"let g:airline_theme='one'
set background=dark
syntax enable
"colorscheme one
"let ayucolor="dark"   " for dark version of theme
"colorscheme ayu

" Vim color file
" vimdefault
" Created by Joey with ThemeCreator (https://github.com/mswift42/themecreator)


if exists("syntax on")
syntax reset
endif

set t_Co=256
"let g:colors_name = "vimdefault"


" Define reusable colorvariables.
let s:bg="#000000"
let s:fg="#ffffff"
let s:fg2="#ebebeb"
let s:fg3="#d6d6d6"
let s:fg4="#c2c2c2"
let s:bg2="#141414"
let s:bg3="#292929"
let s:bg4="#3d3d3d"
let s:keyword="#a65a00"
let s:builtin="#10a500"
let s:const= "#CC0000"
let s:comment="#2d64a4"
let s:func="#00a0e2"
let s:str="#C40000"
let s:type="#3B9B00"
let s:ident="#06989A"
let s:preproc="#75507B"
let s:var="#ffffff"
let s:warning="#e81050"
let s:warning2="#e86310"
let s:parenbg="#3a71c9"
let s:todo="yellow"


exe 'hi Normal guifg='s:fg' guibg='s:bg
exe 'hi Cursor guifg='s:bg' guibg='s:fg
exe 'hi CursorLine  guibg='s:bg2
exe 'hi CursorColumn  guibg='s:bg2
exe 'hi ColorColumn  guibg='s:bg2
exe 'hi LineNr guifg='s:fg2' guibg='s:bg2
exe 'hi VertSplit guifg='s:fg3' guibg='s:bg3
exe 'hi MatchParen guifg='s:fg' guibg='s:parenbg'  gui=none'
exe 'hi Pmenu guifg='s:fg' guibg='s:bg2
exe 'hi PmenuSel  guibg='s:bg3
exe 'hi IncSearch guifg='s:bg' guibg='s:keyword
exe 'hi Directory guifg='s:const
exe 'hi Folded guifg='s:fg4' guibg='s:bg

exe 'hi Boolean guifg='s:const
exe 'hi Character guifg='s:const
exe 'hi Comment guifg='s:comment
exe 'hi Conditional guifg='s:keyword
exe 'hi Constant guifg='s:const
exe 'hi Define guifg='s:keyword
exe 'hi DiffAdd guifg=#000000 guibg=#ddffdd gui=bold'
exe 'hi DiffDelete guifg=#ff0000'
exe 'hi DiffChange  guibg='s:bg2
exe 'hi DiffText guifg=#000000 guibg=#ddddff gui=bold'
exe 'hi ErrorMsg guifg='s:warning' guibg='s:bg2' gui=bold'
exe 'hi WarningMsg guifg='s:fg' guibg='s:warning2
exe 'hi Float guifg='s:const
exe 'hi Function guifg='s:func
exe 'hi Identifier guifg='s:ident'  gui=italic'
exe 'hi Keyword guifg='s:keyword'  gui=bold'
exe 'hi Label guifg='s:var
exe 'hi NonText guifg='s:bg4' guibg='s:bg2
exe 'hi Number guifg='s:const
exe 'hi Operater guifg='s:keyword
exe 'hi PreProc guifg='s:preproc
exe 'hi Special guifg='s:preproc
exe 'hi SpecialKey guifg='s:fg2' guibg='s:bg2
exe 'hi Statement guifg='s:keyword
exe 'hi StorageClass guifg='s:type'  gui=italic'
exe 'hi String guifg='s:str
exe 'hi Tag guifg='s:keyword
exe 'hi Title guifg='s:fg'  gui=bold'
exe 'hi Todo guibg='s:todo' guifg=black  gui=bold'
exe 'hi Type guifg='s:type' gui=none'
exe 'hi Underlined   gui=underline'

" Ruby Highlighting
exe 'hi rubyAttribute guifg='s:builtin
exe 'hi rubyLocalVariableOrMethod guifg='s:var
exe 'hi rubyGlobalVariable guifg='s:var' gui=italic'
exe 'hi rubyInstanceVariable guifg='s:var
exe 'hi rubyKeyword guifg='s:keyword
exe 'hi rubyKeywordAsMethod guifg='s:keyword' gui=bold'
exe 'hi rubyClassDeclaration guifg='s:keyword' gui=bold'
exe 'hi rubyClass guifg='s:keyword' gui=bold'
exe 'hi rubyNumber guifg='s:const

" Python Highlighting
exe 'hi pythonBuiltinFunc guifg='s:builtin

" Go Highlighting
exe 'hi goBuiltins guifg='s:builtin

" Javascript Highlighting
exe 'hi jsBuiltins guifg='s:builtin
exe 'hi jsFunction guifg='s:keyword' gui=bold'
exe 'hi jsGlobalObjects guifg='s:type
exe 'hi jsAssignmentExps guifg='s:var

" Html Highlighting
exe 'hi htmlLink guifg='s:var' gui=underline'
exe 'hi htmlStatement guifg='s:keyword
exe 'hi htmlSpecialTagName guifg='s:keyword

" Markdown Highlighting
exe 'hi mkdCode guifg='s:builtin


" au User asyncomplete_setup call asyncomplete#register_source({
"     \ 'name': 'nim',
"     \ 'whitelist': ['nim'],
"     \ 'triggers': {'nim': ['.'] },
"     \ 'completor': {opt, ctx -> nim#suggest#sug#GetAllCandidates({start, candidates -> asyncomplete#complete(opt['name'], ctx, start, candidates)})}
"     \ })

" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
" imap <silent> . .<Plug>(asyncomplete_force_refresh)

" let g:asyncomplete_auto_popup = 0

" function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <TAB>
"   \ pumvisible() ? "\<C-n>" :
"   \ <SID>check_back_space() ? "\<TAB>" :
"   \ asyncomplete#force_refresh()

"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
" set completeopt+=preview
set rtp+=/usr/local/opt/fzf
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
nnoremap <silent> K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
set switchbuf+=usetab,newtab


autocmd FileType rescript nnoremap <silent> <buffer> <localleader>r :RescriptFormat<CR>
autocmd FileType rescript nnoremap <silent> <buffer> <localleader>t :RescriptTypeHint<CR>
autocmd FileType rescript nnoremap <silent> <buffer> <localleader>b :RescriptBuild<CR>
autocmd FileType rescript nnoremap <silent> <buffer> gd :RescriptJumpToDefinition<CR>

let g:asyncomplete_auto_completeopt=0

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
" set nobackup
" set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
au FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyrightconfig.json', 'env']

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif


" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" kassio/neoterm
let g:neoterm_default_mod = 'vertical botright'
" let g:neoterm_size = 100
let g:neoterm_autoinsert = 1
let g:neoterm_autoscroll = 1
let g:neoterm_term_per_tab = 1
nnoremap <c-t> :Ttoggle<CR>
inoremap <c-t> <Esc>:Ttoggle<CR>
tnoremap <c-t> <c-\><c-n>:Ttoggle<CR>
tnoremap <Esc> <C-\><C-n>

" color scheme
colorscheme codedark
set cursorline
filetype on
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" highlight OverLength ctermbg=red ctermfg=black guibg=#592929 gui=bold

highlight ALEError ctermbg=red guibg=#700000
highlight ALEErrorSign ctermfg=none ctermbg=black guifg=red guibg=#212121
highlight ALEWarning ctermbg=yellow guibg=#504a08
highlight ALEWarningSign ctermfg=yellow ctermbg=none guibg=#212121 guifg=#ecd517
highlight SignColumn ctermbg=darkgrey guibg=#212121
" highlight TabLineFill guibg=none guifg=none gui=none
" highlight TabLineSel guibg=#353535 guifg=none
" highlight TabLine guibg=none guifg=none
highlight CocFadeOut ctermfg=lightgrey guifg=#8B8C92
" highlight CocHintVirtualText guifg=blue ctermbg=none guibg=none
" highlight CocHintHighlight guifg=blue ctermbg=none guibg=none
highlight CocHintSign guifg=#647644 ctermfg=lightblue ctermbg=darkgrey guibg=#212121
highlight CocErrorSign guifg=red ctermfg=red ctermbg=darkgrey guibg=#212121
highlight CocInlayHint guifg=#3D7671 ctermfg=lightblue ctermbg=darkgrey guibg=none
highlight CocHighlightText ctermbg=lightblue guibg=#002c4b


hi Normal ctermbg=none guibg=none
hi EndOfBuffer ctermbg=none guibg=none
"hi SignColumn ctermbg=none guibg=none
hi NonText ctermbg=none guibg=none
hi LineNr ctermbg=none guibg=none
"hi CursorLine  cterm=NONE ctermbg=black ctermfg=NONE guibg=black gui=NONE guifg=NONE
set noshowmode

" let g:opamshare = substitute(system('opam var share'),'\n$','','''')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
" let s:opam_share_dir = system("opam config var share")
" let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

" let s:opam_configuration = {}

" function! OpamConfOcpIndent()
"   execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
" endfunction
" let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

" function! OpamConfOcpIndex()
"   execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
" endfunction
" let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

" function! OpamConfMerlin()
"   let l:dir = s:opam_share_dir . "/merlin/vim"
"   execute "set rtp+=" . l:dir
" endfunction
" let s:opam_configuration['merlin'] = function('OpamConfMerlin')

" let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
" let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
" let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
" for tool in s:opam_packages
"   " Respect package order (merlin should be after ocp-index)
"   if count(s:opam_available_tools, tool) > 0
"     call s:opam_configuration[tool]()
"   endif
" endfor

" ## end of OPAM user-setup addition for vim / base ## keep this line
let g:ale_linters = {'java': [], 'python': []}

" " for normal mode - the word under the cursor
" nmap <Leader>di <Plug>VimspectorBalloonEval
" " for visual mode, the visually selected text
" xmap <Leader>di <Plug>VimspectorBalloonEval
" let g:vimspector_enable_mappings = 'HUMAN'

" nnoremap <leader><space> :GFiles<CR>

" nvim-telescope/telescope.nvim

lua << EOF
require('hologram').setup{
    auto_display = true -- WIP automatic markdown image display, may be prone to breaking
}
_G.telescope_find_files_in_path = function(path)
 local _path = path or vim.fn.input("Dir: ", "", "dir")
 require("telescope.builtin").find_files({search_dirs = {_path}})
end
EOF

lua << EOF
_G.telescope_live_grep_in_path = function(path)
 local _path = path or vim.fn.input("Dir: ", "", "dir")
 require("telescope.builtin").live_grep({search_dirs = {_path}})
end
EOF

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "help", "go", "python" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "python", "nim" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

let b:current_syntax = 'nim'

nnoremap <leader><space> :Telescope git_files<CR>
nnoremap <leader>fd :lua telescope_find_files_in_path()<CR>
nnoremap <leader>fD :lua telescope_live_grep_in_path()<CR>
nnoremap <leader>ft :lua telescope_find_files_in_path("./tests")<CR>
nnoremap <leader>fT :lua telescope_live_grep_in_path("./tests")<CR>
" nnoremap <leader>ff :Telescope live_grep<CR>
nnoremap <leader>fo :Telescope file_browser<CR>
nnoremap <leader>fn :Telescope find_files<CR>
nnoremap <leader>fg :Telescope git_branches<CR>
nnoremap <leader>fb :Telescope buffers<CR>
nnoremap <leader>fs :Telescope lsp_document_symbols<CR>
nnoremap <leader>ff :Telescope live_grep<CR>
nnoremap <leader>FF :Telescope grep_string<CR>

" mfussenegger/nvim-dap
lua << EOF
local dap = require('dap')

function os.capture(cmd)
  local f = assert(io.popen(cmd .. ' 2>&1', 'r'))
  local s = assert(f:read('*a'))
  f:close()
  return s
end

dap.adapters.lldb = {
  type = 'executable',
  command = '/opt/homebrew/opt/llvm/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}
dap.configurations.nim = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
        -- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')

        print("Compiling...")
        local filename = vim.api.nvim_buf_get_name(0)
        local res = os.capture('nim c --debugger:native ' .. filename)
        print("Running...")
        return filename:match("(.+)%..+$");
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function()
        return vim.fn.input('Args: ', '')
    end,
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false
  },
}

require('dap-python').setup('/opt/homebrew/bin/python3')

-- If you want to use this for rust and c, add something like this:

-- dap.configurations.c = dap.configurations.cpp
-- dap.configurations.nim = dap.configurations.cpp

vim.fn.sign_define('DapBreakpoint', {text='●', texthl='ErrorMsg', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='●', texthl='LineNr', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='L', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='→', texthl='WarningMsg', linehl='debugPC', numhl=''})
EOF

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun


au FileType dap-repl lua require('dap.ext.autocompl').attach()

nnoremap <silent> <ESC> :lua for _, win in ipairs(vim.api.nvim_list_wins()) do local config = vim.api.nvim_win_get_config(win); if config.relative ~= "" then vim.api.nvim_win_close(win, false) end end <ESC>
nnoremap <silent> <leader>db :lua require'dap'.toggle_breakpoint()<CR>
" option-o 
nnoremap <silent> ø :lua require'dap'.step_out()<CR>
" option-K
nnoremap <silent> ˚ :lua require'dap'.step_into()<CR>
" option-J
nnoremap <silent> ∆ :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>ds :lua require'dap'.close()<CR>
nnoremap <silent> <leader>dn :lua require'dap'.continue()<CR>
nnoremap <silent> <leader>dk :lua require'dap'.up()<CR>
nnoremap <silent> <leader>dj :lua require'dap'.down()<CR>
nnoremap <silent> <leader>d_ :lua require'dap'.disconnect();require'dap'.stop();require'dap'.run_last()<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.toggle()<CR><C-w>l
nnoremap <silent> <leader>rc :lua require'dap'.run_to_cursor()<CR><C-w>l
nnoremap <silent> <leader>rb :lua require'dap'.reverse_continue()<CR><C-w>l
"nnoremap <silent> <leader>di :lua require'dap.ui.variables'.hover()<CR>
vnoremap <silent> <leader>di :lua require'dap.ui.variables'.visual_hover()<CR>
nnoremap <silent> <leader>d? :lua require'dap.ui.variables'.scopes()<CR>
nnoremap <silent> <leader>de :lua require'dap'.set_exception_breakpoints({"all"})<CR>
nnoremap <silent> <leader>da :lua require'debugHelper'.attach()<CR>
nnoremap <silent> <leader>dA :lua require'debugHelper'.attachToRemote()<CR>
nnoremap <silent> <leader>di :lua require'dap.ui.widgets'.hover()<CR>
nnoremap <silent> <leader>qq :q<CR>
nnoremap <silent> <leader>d? :lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>

" Plug 'nvim-telescope/telescope-dap.nvim'
lua << EOF
require('telescope').setup()
require('telescope').load_extension('dap')
EOF
nnoremap <leader>df :Telescope dap frames<CR>
nnoremap <leader>dc :Telescope dap commands<CR>
nnoremap <leader>dh :Telescope dap list_breakpoints<CR>

" theHamsta/nvim-dap-virtual-text and mfussenegger/nvim-dap
let g:dap_virtual_text = v:true

" TimUntersberger/neogit and sindrets/diffview.nvim
lua << EOF
require("neogit").setup {
  disable_commit_confirmation = true,
  integrations = {
    diffview = true
    }
  }
EOF
nnoremap <leader>gg :Neogit<cr>
nnoremap <leader>gd :DiffviewOpen<cr>
nnoremap <leader>gD :DiffviewOpen main<cr>
nnoremap <leader>gl :Neogit log<cr>
nnoremap <leader>gp :Neogit push<cr>


hi GitSignsAdd ctermfg=green ctermbg=none guibg=#212121 guifg=#32cd32 gui=bold cterm=bold
hi GitSignsDelete ctermfg=red ctermbg=none guibg=#212121 guifg=#ff6347 gui=bold cterm=bold
hi GitSignsChange ctermfg=blue ctermbg=none guibg=#212121 guifg=#1e90ff gui=bold cterm=bold

hi GitSignsAddInline ctermfg=none ctermbg=none guibg=#306C37 guifg=none gui=bold cterm=bold
hi GitSignsDeleteInline ctermfg=red ctermbg=none guibg=#740009 guifg=none gui=bold cterm=bold
hi GitSignsChangeInline ctermfg=blue ctermbg=none guibg=#0043AE guifg=none gui=bold cterm=bold

hi GitSignsAddLnInline ctermfg=green ctermbg=none guibg=#306C37 guifg=none gui=bold cterm=bold
hi GitSignsDeleteLnInline ctermfg=red ctermbg=none guibg=#740009 guifg=none gui=bold cterm=bold
hi GitSignsChangeLnInline ctermfg=blue ctermbg=none guibg=#0043AE guifg=none gui=bold cterm=bold

hi GitSignsAddVirtLnInline ctermfg=green ctermbg=none guibg=#306C37 guifg=none gui=bold cterm=bold
hi GitSignsDeleteVirtLnInline ctermfg=red ctermbg=none guibg=#740009 guifg=none gui=bold cterm=bold
hi GitSignsChangeVirtLnInline ctermfg=blue ctermbg=none guibg=#0043AE guifg=none gui=bold cterm=bold

nmap <F1> :CocCommand java.debug.vimspector.start<CR>
" nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


" Nim: replace comment above with comment below
let @t = '/^proc ?^\_[\n]##V/\_[�kb�kb�kb^\_[\n\�kb]prc�kboc m/\.}pdd'
let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q"
