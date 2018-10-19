let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Downloads/nimforum
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +37 ~/Projects/nim-libnx/src/libnx/wrapper/acc.nim
badd +36 /opt/devkitpro/examples/switch/account/source/main.c
badd +43 ~/Projects/nim-libnx/src/libnx/wrapper/sm.nim
badd +94 ~/Projects/nim-libnx/src/libnx/wrapper/nx/include/switch/result.h
badd +79 ~/Nim/lib/core/macros.nim
badd +64 ~/Nim/lib/core/strs.nim
badd +20 ~/Projects/nim-libnx/src/libnx/wrapper/nx/include/switch/services/acc.h
badd +15 ~/Projects/nim-libnx/src/libnx/wrapper/nx/include/switch/services/sm.h
badd +16 ~/Projects/nim-libnx/examples/helloworld/helloworld.nim
badd +2 ~/Projects/nim-libnx/examples/helloworld/helloworld.nim.cfg
badd +2 ~/Projects/nim-libnx/src/libnx/wrapper/gfx.nim
badd +104 ~/Projects/nim-libnx/src/libnx/wrapper/nx/include/switch/gfx/gfx.h
badd +11 /opt/devkitpro/examples/switch/graphics/printing/hello-world/source/main.c
badd +2 ~/Projects/nim-libnx/examples/accounts/account_ex.nim
badd +4 ~/Projects/nim-libnx/libnx.nimble
badd +223 ~/Projects/nim-libnx/src/libnx/account.nim
badd +317 ~/Projects/nim-libnx/src/libnx/ext/integer128.nim
badd +5 ~/Projects/nim-libnx/src/libnx/wrapper/types.nim
badd +2 ~/Projects/nim-libnx/src/libnx/results.nim
badd +9 ~/Projects/nim-libnx/src/libnx/graphics.nim
badd +97 ~/Projects/nim-libnx/src/libnx/utils.nim
badd +1 ~/Projects/nim-libnx/src/libnx/wrapper/buffer_producer.nim
badd +101 ~/Projects/nim-libnx/libnxGen.cfg
badd +4 ~/Projects/nim-libnx/TODO.md
badd +46 ~/Projects/nim-libnx/src/libnx/service.nim
badd +375 ~/Projects/nim-libnx/src/libnx/input.nim
badd +477 ~/Projects/nim-libnx/src/libnx/wrapper/hid.nim
badd +46 ~/Projects/nim-libnx/src/libnx/console.nim
badd +5 ~/Projects/nim-libnx/src/libnx/wrapper/con.nim
badd +1 ~/Projects/nim-libnx/removeStaticBodies.nim
badd +265 ~/Projects/switch-build/src/switch_build.nim
badd +1 tests/browsertester.nim
badd +48 tests/browsertests/scenario1.nim
badd +29 tests/browsertests/posts.nim
badd +46 tests/browsertests/common.nim
badd +85 src/frontend/forum.nim
badd +1 src/frontend/newthread.nim
badd +1 src/frontend/threadlist.nim
badd +85 src/frontend/replybox.nim
badd +1 src/frontend/postlist.nim
badd +23 src/frontend/post.nim
badd +14 tests/browsertests/threads.nim
badd +55 src/frontend/usermenu.nim
badd +91 src/frontend/editbox.nim
badd +1 src/frontend/signup.nim
badd +110 src/frontend/delete.nim
badd +119 src/frontend/profile.nim
badd +181 src/frontend/profilesettings.nim
badd +75 src/frontend/user.nim
badd +1 tests/browsertests/issue181.nim
argglobal
silent! argdel *
$argadd tests/browsertester.nim
set stal=2
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabnew
tabnext -11
edit tests/browsertester.nim
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
49
normal! zo
61
normal! zo
let s:l = 66 - ((26 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
66
normal! 034|
tabnext
edit tests/browsertests/issue181.nim
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
11
normal! zo
let s:l = 22 - ((21 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
22
normal! 012|
tabnext
edit tests/browsertests/scenario1.nim
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
22
normal! zo
let s:l = 34 - ((33 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
34
normal! 017|
tabnext
edit tests/browsertests/threads.nim
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
13
normal! zo
19
normal! zo
20
normal! zo
58
normal! zo
59
normal! zo
80
normal! zo
81
normal! zo
let s:l = 46 - ((45 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
46
normal! 022|
tabnext
edit tests/browsertests/common.nim
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
62
normal! zo
78
normal! zo
91
normal! zo
100
normal! zo
119
normal! zo
140
normal! zo
let s:l = 98 - ((10 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
98
normal! 0
tabnext
edit src/frontend/profilesettings.nim
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
let s:l = 46 - ((45 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
46
normal! 038|
tabnext
edit src/frontend/profile.nim
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
let s:l = 46 - ((45 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
46
normal! 07|
tabnext
edit src/frontend/signup.nim
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
2
normal! zo
49
normal! zo
52
normal! zo
53
normal! zo
57
normal! zo
58
normal! zo
64
normal! zo
65
normal! zo
66
normal! zo
81
normal! zo
82
normal! zo
82
normal! zo
82
normal! zo
82
normal! zo
82
normal! zo
82
normal! zo
82
normal! zo
82
normal! zo
91
normal! zo
let s:l = 46 - ((45 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
46
normal! 022|
tabnext
edit src/frontend/threadlist.nim
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
29
normal! zo
113
normal! zo
let s:l = 9 - ((8 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
9
normal! 023|
tabnext
edit src/frontend/newthread.nim
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
2
normal! zo
46
normal! zo
47
normal! zo
48
normal! zo
49
normal! zo
61
normal! zo
62
normal! zo
62
normal! zo
62
normal! zo
let s:l = 64 - ((29 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
64
normal! 021|
tabnext
edit src/frontend/postlist.nim
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
17
normal! zo
221
normal! zo
226
normal! zo
227
normal! zo
231
normal! zo
310
normal! zo
310
normal! zo
310
normal! zo
310
normal! zo
310
normal! zo
310
normal! zo
310
normal! zo
310
normal! zo
310
normal! zo
331
normal! zo
332
normal! zo
333
normal! zo
343
normal! zo
344
normal! zo
344
normal! zo
let s:l = 338 - ((22 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
338
normal! 026|
tabnext
edit src/frontend/post.nim
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
let s:l = 28 - ((21 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
28
normal! 016|
tabnext 9
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
