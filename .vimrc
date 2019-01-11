map <ESC>[1;5A <C-Up>
map <ESC>[1;5B <C-Down>
map <ESC>[1;5C <C-Right>
map <ESC>[1;5D <C-Left>

let mapleader = "\<Space>"

let g:syntastic_c_compiler_options = "-std=c99"

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
let g:airline_section_x = ''
let g:airline_section_y = ''


set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=10000
set undoreload=10000        " number of lines to save for undo
filetype plugin indent on
set pastetoggle=<F2>
set incsearch
set title

set ttymouse=xterm2
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
call ToggleJSFormat()

" autocmd BufNew * if winnr('$') == 1 | tabmove99 | endif

set hlsearch
highlight Search ctermbg=blue ctermfg=white guibg=blue

filetype on
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
highlight OverLength ctermbg=red ctermfg=black guibg=darkred

highlight ALEError ctermfg=black ctermbg=red guifg=black guibg=red

au! FileType python setl nosmartindent
au BufRead,BufNewFile *.py,*.js,*.jsx,*.nim,*.ml,*.mli match OverLength /\%89v.\+/
au BufRead,BufNewFile *.py,*.js,*.jsx,*.nim,*.ml,*.mli 2match ExtraWhiteSpace /\s\+$\|\t/
au StdinReadPost * set buftype=nofile
syntax on

command C let @/=""
command CC :%s#_\(\l\)#\u\1#g
command U :%s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g

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

set rtp^="/home/joey/.opam/4.05.0/share/ocp-indent/vim"
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

au FileType ocaml call SuperTabSetDefaultCompletionType("<c-x><c-o>")

execute "set <A-h>=h"
execute "set <A-j>=j"
execute "set <A-k>=k"
execute "set <A-l>=l"

noremap <A-k> :tabr<cr>
noremap <A-j> :tabl<cr>
noremap <A-h> gT
noremap <A-l> gt

inoremap <A-k> <Esc>:tabr<cr>i
inoremap <A-j> <Esc>:tabl<cr>i
inoremap <A-h> <Esc>gTi
inoremap <A-l> <Esc>gti


"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_wq = 0

call plug#begin('~/.vim/plugged')
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
Plug 'dag/vim-fish'
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
Plug 'chriskempson/base16-vim'
Plug 'w0rp/ale'
Plug 'kien/ctrlp.vim'
Plug 'udalov/kotlin-vim'
Plug 'ervandew/supertab'
Plug 'simnalamburt/vim-mundo'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dart-lang/dart-vim-plugin'
"Plug 'baabelfish/nvim-nim'
call plug#end()

nnoremap <F6> :MundoToggle<CR>

"let base16colorspace=256
" set background=dark
"colorscheme base16-default-dark
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
autocmd Filetype ocaml setlocal ts=2 sts=2 sw=2 expandtab

"colorscheme tender

hi Normal ctermbg=none
hi NonText ctermbg=none
hi CursorLine  cterm=NONE ctermbg=black ctermfg=NONE
set noshowmode
