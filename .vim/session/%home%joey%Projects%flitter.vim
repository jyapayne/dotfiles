let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Projects/flitter
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +62 Makefile
badd +232 ~/Downloads/pfff/Makefile
badd +46 main_test.ml
badd +22 lang_cpp/parsing/Makefile
badd +11 generators/nim/Makefile
badd +1 generators/nim/unit_generate_nim.mli
badd +67 generators/nim/unit_generate_nim.ml
badd +97 lang_cpp/parsing/test_parsing_cpp.ml
badd +852 generators/nim/generate.ml
badd +188 lang_cpp/parsing/parse_cpp.ml
badd +1198 commons/common.ml
badd +74 main.ml
badd +858 generators/nim/generate_nim.ml
badd +1 generators/nim/generate_nim.mli
badd +12 lang_cpp/parsing/test_parsing_cpp.mli
badd +15 lang_cpp/parsing/flag_parsing_cpp.ml
badd +7 globals/config_pfff.ml
badd +65 lang_cpp/parsing/unit_parsing_cpp.ml
badd +110 ~/.vimrc
badd +1 tests/generators/nim/test_func1.c
badd +1 tests/generators/nim/test_func1.v
badd +1 tests/generators/nim/test_func1.nim
badd +1 g.nim
badd +1 tests/generators/nim/test_func2.c
badd +1 tests/generators/nim/test_func2.nim
badd +829 lang_cpp/parsing/meta_ast_cpp.ml
badd +412 lang_cpp/parsing/ast_cpp.ml
badd +2917 commons/common2.ml
argglobal
silent! argdel *
$argadd Makefile
$argadd ~/Downloads/pfff/Makefile
set stal=2
edit generators/nim/generate_nim.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists('generators/nim/generate_nim.ml') | buffer generators/nim/generate_nim.ml | else | edit generators/nim/generate_nim.ml | endif
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 858 - ((22 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
858
normal! 07|
tabedit generators/nim/Makefile
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists('generators/nim/Makefile') | buffer generators/nim/Makefile | else | edit generators/nim/Makefile | endif
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 11 - ((2 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
11
normal! 026|
tabedit Makefile
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
let s:l = 71 - ((22 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
71
normal! 07|
tabedit generators/nim/unit_generate_nim.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists('generators/nim/unit_generate_nim.ml') | buffer generators/nim/unit_generate_nim.ml | else | edit generators/nim/unit_generate_nim.ml | endif
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
12
normal! zo
23
normal! zo
34
normal! zo
40
normal! zo
47
normal! zo
48
normal! zo
48
normal! zo
50
normal! zo
50
normal! zo
50
normal! zo
50
normal! zo
50
normal! zo
59
normal! zo
let s:l = 53 - ((13 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
53
normal! 037|
tabedit lang_cpp/parsing/meta_ast_cpp.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists('lang_cpp/parsing/meta_ast_cpp.ml') | buffer lang_cpp/parsing/meta_ast_cpp.ml | else | edit lang_cpp/parsing/meta_ast_cpp.ml | endif
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
141
normal! zo
153
normal! zo
155
normal! zo
171
normal! zo
174
normal! zo
242
normal! zo
244
normal! zo
262
normal! zo
267
normal! zo
271
normal! zo
275
normal! zo
288
normal! zo
292
normal! zo
296
normal! zo
319
normal! zo
374
normal! zo
466
normal! zo
488
normal! zo
507
normal! zo
605
normal! zo
617
normal! zo
617
normal! zo
618
normal! zo
620
normal! zo
645
normal! zo
658
normal! zo
659
normal! zo
689
normal! zo
693
normal! zo
745
normal! zo
746
normal! zo
746
normal! zo
746
normal! zo
746
normal! zo
746
normal! zo
746
normal! zo
746
normal! zo
746
normal! zo
746
normal! zo
746
normal! zo
764
normal! zo
831
normal! zo
862
normal! zo
883
normal! zo
889
normal! zo
908
normal! zo
927
normal! zo
927
normal! zo
928
normal! zo
930
normal! zo
945
normal! zo
957
normal! zo
964
normal! zo
990
normal! zo
1030
normal! zo
1050
normal! zo
1055
normal! zo
1064
normal! zo
let s:l = 1069 - ((9 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1069
normal! 032|
tabedit lang_cpp/parsing/ast_cpp.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists('lang_cpp/parsing/ast_cpp.ml') | buffer lang_cpp/parsing/ast_cpp.ml | else | edit lang_cpp/parsing/ast_cpp.ml | endif
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
230
normal! zo
338
normal! zo
338
normal! zo
376
normal! zo
591
normal! zo
614
normal! zo
let s:l = 618 - ((22 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
618
normal! 07|
tabedit generators/nim/generate_nim.mli
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists('generators/nim/generate_nim.mli') | buffer generators/nim/generate_nim.mli | else | edit generators/nim/generate_nim.mli | endif
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 1 - ((0 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 018|
tabedit lang_cpp/parsing/parse_cpp.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists('lang_cpp/parsing/parse_cpp.ml') | buffer lang_cpp/parsing/parse_cpp.ml | else | edit lang_cpp/parsing/parse_cpp.ml | endif
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
257
normal! zo
let s:l = 188 - ((14 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
188
normal! 09|
tabedit lang_cpp/parsing/unit_parsing_cpp.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists('lang_cpp/parsing/unit_parsing_cpp.ml') | buffer lang_cpp/parsing/unit_parsing_cpp.ml | else | edit lang_cpp/parsing/unit_parsing_cpp.ml | endif
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 65 - ((22 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
65
normal! 016|
tabedit generators/nim/Makefile
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists('generators/nim/Makefile') | buffer generators/nim/Makefile | else | edit generators/nim/Makefile | endif
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 9 - ((8 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
9
normal! 06|
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
