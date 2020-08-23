map <ESC>[1;5A <C-Up>
map <ESC>[1;5B <C-Down>
map <ESC>[1;5C <C-Right>
map <ESC>[1;5D <C-Left>
nnoremap gm m
let g:ale_shell="/bin/bash"

" Live updating substitution!
set inccommand=nosplit
let g:airline#extensions#ale#enabled = 1

let mapleader = "\<Space>"
let maplocalleader = "\<Space>"
let g:asyncomplete_auto_popup = 0

let g:syntastic_c_compiler_options = "-std=c99"
set guicursor=

inoremap vmark ✓

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
set shell=/bin/bash\ --login
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
let g:python_version_2 = 1
let g:jsx_ext_required = 0
let g:asyncrun_auto = "make"
let g:syntastic_enable_elixir_checker = 1
let g:syntastic_elixir_checkers = ['elixir']
let g:LargeFile = 20
"set  rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
set laststatus=2
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline_section_warning = ''
let g:airline_section_z = '%l/%L:%c'
let g:airline_symbols.dirty="\u2021"
let g:airline_symbols.crypt="\ue0a2"


set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=10000
set undoreload=10000        " number of lines to save for undo
filetype plugin indent on
set pastetoggle=<F2>
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

nmap =j :%!python -m json.tool<CR>

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
nn <C-g> :call JumpToDef()<cr>
ino <C-g> <esc>:call JumpToDef()<cr>i

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


noremap <A-k> <C-u>
noremap <A-j> <C-d>
noremap <A-h> gT
noremap <A-l> gt

inoremap <A-k> <Esc><C-u>i
inoremap <A-j> <Esc><C-d>i
inoremap <A-h> <Esc>gTi
inoremap <A-l> <Esc>gti

set clipboard=
let g:EasyClipShareYanks = 1


"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_wq = 0

call plug#begin('~/.local/share/nvim/plugged')
Plug 'rust-lang/rust.vim'
Plug 'zah/nim.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'scrooloose/nerdtree'
Plug 'hynek/vim-python-pep8-indent'
Plug 'pangloss/vim-javascript'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'tpope/vim-haml'
Plug 'hdima/python-syntax'
Plug 'hail2u/vim-css3-syntax'
Plug 'mxw/vim-jsx'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
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
Plug 'ervandew/supertab'
Plug 'simnalamburt/vim-mundo'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-surround'
Plug 'alaviss/nim.nvim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'tpope/vim-repeat'
Plug 'christoomey/vim-sort-motion'
Plug 'christoomey/vim-system-copy'
Plug 'michaeljsmith/vim-indent-object'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'Julian/vim-textobj-brace'
Plug 'bps/vim-textobj-python'
Plug 'svermeulen/vim-easyclip'
"Plug 'baabelfish/nvim-nim'
call plug#end()

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors

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
let g:colors_name = "vimdefault"


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

set hlsearch
highlight Search ctermbg=blue ctermfg=white guibg=#006891 guifg=white
highlight IncSearch ctermbg=blue ctermfg=white guifg=#7D008D guibg=white

filetype on
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
highlight OverLength ctermbg=red ctermfg=black guibg=#592929 gui=bold

highlight ALEError ctermfg=black ctermbg=red guifg=black guibg=red
highlight ALEErrorSign ctermfg=none ctermbg=black guifg=red guibg=#212121
highlight ALEWarning ctermfg=black ctermbg=yellow guifg=black guibg=#a09500
highlight ALEWarningSign ctermfg=yellow ctermbg=none guibg=#212121 guifg=#a09500
highlight SignColumn ctermbg=darkgrey guibg=#212121
highlight TabLineFill guibg=none guifg=none gui=none
highlight TabLineSel guibg=#353535 guifg=none
highlight TabLine guibg=none guifg=none

hi Normal ctermbg=none guibg=none
hi NonText ctermbg=none guibg=none
hi CursorLine  cterm=NONE ctermbg=black ctermfg=NONE guibg=black gui=NONE guifg=NONE
set noshowmode
let g:asyncomplete_auto_popup = 0
au User asyncomplete_setup call asyncomplete#register_source({
    \ 'name': 'nim',
    \ 'whitelist': ['nim'],
    \ 'triggers': {'*': ['.'] },
    \ 'completor': {opt, ctx -> nim#suggest#sug#GetAllCandidates({start, candidates -> asyncomplete#complete(opt['name'], ctx, start, candidates)})}
    \ })
