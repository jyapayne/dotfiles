let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Projects/nim-libnx
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +37 src/libnx/wrapper/acc.nim
badd +36 /opt/devkitpro/examples/switch/account/source/main.c
badd +43 src/libnx/wrapper/sm.nim
badd +94 src/libnx/wrapper/nx/include/switch/result.h
badd +79 ~/Nim/lib/core/macros.nim
badd +64 ~/Nim/lib/core/strs.nim
badd +20 src/libnx/wrapper/nx/include/switch/services/acc.h
badd +15 src/libnx/wrapper/nx/include/switch/services/sm.h
badd +16 examples/helloworld/helloworld.nim
badd +2 examples/helloworld/helloworld.nim.cfg
badd +2 src/libnx/wrapper/gfx.nim
badd +104 src/libnx/wrapper/nx/include/switch/gfx/gfx.h
badd +11 /opt/devkitpro/examples/switch/graphics/printing/hello-world/source/main.c
badd +3 examples/accounts/account_ex.nim
badd +4 libnx.nimble
badd +223 src/libnx/account.nim
badd +317 src/libnx/ext/integer128.nim
badd +5 src/libnx/wrapper/types.nim
badd +46 src/libnx/results.nim
badd +9 src/libnx/graphics.nim
badd +97 src/libnx/utils.nim
badd +1 src/libnx/wrapper/buffer_producer.nim
badd +329 libnxGen.cfg
badd +1 TODO.md
badd +46 src/libnx/service.nim
badd +433 src/libnx/input.nim
badd +20 src/libnx/wrapper/hid.nim
badd +46 src/libnx/console.nim
badd +1 src/libnx/wrapper/con.nim
badd +1 removeStaticBodies.nim
badd +253 ~/Projects/switch-build/src/switch_build.nim
badd +57 examples/input/vibration.nim
argglobal
silent! argdel *
$argadd examples/accounts/account_ex.nim
set stal=2
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabnext -8
edit examples/accounts/account_ex.nim
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
6
normal! zo
12
normal! zo
13
normal! zo
28
normal! zo
39
normal! zo
let s:l = 16 - ((12 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
16
normal! 0
tabnext
edit examples/input/vibration.nim
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
6
normal! zo
37
normal! zo
let s:l = 54 - ((29 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
54
normal! 07|
tabnext
edit src/libnx/input.nim
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
23
normal! zo
70
normal! zo
196
normal! zo
199
normal! zo
215
normal! zo
244
normal! zo
250
normal! zo
275
normal! zo
292
normal! zo
311
normal! zo
317
normal! zo
332
normal! zo
349
normal! zo
354
normal! zo
let s:l = 342 - ((12 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
342
normal! 045|
tabnext
edit src/libnx/console.nim
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
let s:l = 116 - ((21 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
116
normal! 07|
tabnext
edit src/libnx/wrapper/hid.nim
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
30
normal! zo
403
normal! zo
412
normal! zo
let s:l = 520 - ((23 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
520
normal! 05|
tabnext
edit src/libnx/results.nim
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
91
normal! zo
105
normal! zo
let s:l = 103 - ((30 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
103
normal! 023|
tabnext
edit libnxGen.cfg
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
let s:l = 101 - ((13 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
101
normal! 0
tabnext
edit src/libnx/wrapper/types.nim
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
let s:l = 5 - ((4 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5
normal! 0
tabnext
edit TODO.md
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
let s:l = 4 - ((3 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4
normal! 0
tabnext 3
set stal=1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
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
