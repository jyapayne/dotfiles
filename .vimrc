" this is necessary to get the "indent paragraph" command to work
"

set autoindent
set ruler

set backspace=2
set autowrite

set smarttab

set expandtab
set nocompatible
set foldmethod=indent
set foldlevel=99
let g:python_highlight_all=1
let g:python_version_2 = 1
map <C-n> :NERDTreeTabsToggle<CR>

set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=10000
set undoreload=10000        " number of lines to save for undo
filetype plugin indent on
set pastetoggle=<F2>
set incsearch
set title

set mouse=a
set tabstop=4
set shiftwidth=4

set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_check_on_wq = 0

autocmd Filetype nim setlocal ts=2 sts=2 sw=2 expandtab

set hlsearch
highlight Search ctermbg=blue ctermfg=white guibg=blue

filetype on
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
:match ExtraWhitespace /\s\+$/
highlight OverLength ctermbg=red ctermfg=white guibg=darkred
2match OverLength /\%81v.*/

au! FileType python setl nosmartindent
au BufRead,BufNewFile *.py syntax match OverLength /\%80v.\+/
au BufRead,BufNewFile *.py,*.js syntax match ExtraWhiteSpace /\s\+$\|\t/
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
set runtimepath^=~/.vim/bundle/ctrlp.vim
nmap <F8> :TagbarToggle<CR>

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

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

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_of_chars_for_completion = 99

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_wq = 0

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/vundle'
Plugin 'zah/nim.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-syntastic/syntastic'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'pangloss/vim-javascript'
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'tpope/vim-haml'
Plugin 'hdima/python-syntax'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'mxw/vim-jsx'
Plugin 'elixir-lang/vim-elixir'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
call vundle#end()            " required
filetype plugin indent on
