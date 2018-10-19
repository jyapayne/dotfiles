let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Nim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +113 config/nim.cfg
badd +21 compiler/platform.nim
badd +642 compiler/extccomp.nim
badd +431 lib/system/sysio.nim
badd +1 lib/pure/oids.nim
badd +1289 lib/pure/os.nim
badd +359 compiler/options.nim
badd +1416 lib/system.nim
badd +1026 compiler/ccgexprs.nim
badd +1 lib/system/osalloc.nim
badd +1 lib/system/mmdisp.nim
badd +43 lib/genode/alloc.nim
badd +1 lib/nintendoswitch/switch_memory.nim
badd +1 lib/nintendoswitch/alloc.nim
argglobal
silent! argdel *
$argadd lib/system/osalloc.nim
set stal=2
edit lib/system/osalloc.nim
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
32
normal! zo
84
normal! zo
95
normal! zo
103
normal! zo
111
normal! zo
115
normal! zo
155
normal! zo
195
normal! zo
let s:l = 107 - ((20 * winheight(0) + 11) / 22)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
107
normal! 014|
tabedit lib/nintendoswitch/switch_memory.nim
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
8
normal! zo
11
normal! zo
14
normal! zo
17
normal! zo
20
normal! zo
22
normal! zo
let s:l = 19 - ((18 * winheight(0) + 11) / 22)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
19
normal! 0
tabedit lib/system/mmdisp.nim
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 40 - ((3 * winheight(0) + 11) / 22)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
40
normal! 0
tabnext 1
set stal=1
if exists('s:wipebuf') && s:wipebuf != bufnr('%')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
let g:this_session = v:this_session
let g:this_obsession = v:this_session
let g:this_obsession_status = 2
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
