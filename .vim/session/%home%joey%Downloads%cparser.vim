let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Downloads/cparser
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +9 t2.c
badd +492 lang_cpp/parsing/test_parsing_cpp.ml
badd +169 lang_cpp/parsing/parse_cpp.ml
badd +239 ~/.vimrc
badd +16 .merlin
badd +1 lang_cpp/.merlin
badd +1 lang_cpp/parsing/.merlin
badd +46 main.ml
badd +228 lang_cpp/parsing/ast_cpp.ml
badd +118 lang_cpp/parsing/meta_ast_cpp.ml
badd +564 h_program-lang/parse_info.ml
badd +274 commons/ocaml.ml
badd +513 lang_cpp/parsing/test_dump_nim.ml
badd +3 lang_cpp/parsing/test_parsing_cpp.mli
badd +2 lang_cpp/parsing/test_dump_nim.mli
argglobal
silent! argdel *
$argadd t2.c
set stal=2
edit lang_cpp/parsing/parse_cpp.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
93
normal! zo
let s:l = 169 - ((22 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
169
normal! 021|
tabedit main.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
153
normal! zo
let s:l = 46 - ((35 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
46
normal! 03|
tabedit lang_cpp/parsing/test_parsing_cpp.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
31
normal! zo
52
normal! zo
96
normal! zo
let s:l = 91 - ((21 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
91
normal! 075|
tabedit lang_cpp/parsing/test_dump_nim.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
163
normal! zo
173
normal! zo
236
normal! zo
240
normal! zo
242
normal! zo
244
normal! zo
248
normal! zo
250
normal! zo
250
normal! zo
255
normal! zo
270
normal! zo
279
normal! zo
285
normal! zo
289
normal! zo
431
normal! zo
457
normal! zo
486
normal! zo
493
normal! zo
498
normal! zo
499
normal! zo
508
normal! zo
510
normal! zo
512
normal! zo
514
normal! zo
516
normal! zo
520
normal! zo
527
normal! zo
527
normal! zo
532
normal! zo
536
normal! zo
541
normal! zo
543
normal! zo
545
normal! zo
547
normal! zo
551
normal! zo
565
normal! zo
567
normal! zo
571
normal! zo
574
normal! zo
576
normal! zo
579
normal! zo
618
normal! zo
620
normal! zo
632
normal! zo
696
normal! zo
700
normal! zo
733
normal! zo
766
normal! zo
777
normal! zo
804
normal! zo
let s:l = 523 - ((19 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
523
normal! 067|
tabedit lang_cpp/parsing/meta_ast_cpp.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
26
normal! zo
80
normal! zo
82
normal! zo
83
normal! zo
91
normal! zo
105
normal! zo
113
normal! zo
120
normal! zo
122
normal! zo
141
normal! zo
143
normal! zo
149
normal! zo
153
normal! zo
155
normal! zo
160
normal! zo
171
normal! zo
174
normal! zo
215
normal! zo
217
normal! zo
218
normal! zo
242
normal! zo
244
normal! zo
249
normal! zo
288
normal! zo
292
normal! zo
300
normal! zo
304
normal! zo
308
normal! zo
312
normal! zo
319
normal! zo
324
normal! zo
332
normal! zo
337
normal! zo
344
normal! zo
348
normal! zo
352
normal! zo
355
normal! zo
364
normal! zo
368
normal! zo
488
normal! zo
490
normal! zo
495
normal! zo
507
normal! zo
522
normal! zo
528
normal! zo
532
normal! zo
539
normal! zo
541
normal! zo
548
normal! zo
553
normal! zo
555
normal! zo
560
normal! zo
567
normal! zo
567
normal! zo
569
normal! zo
579
normal! zo
605
normal! zo
607
normal! zo
611
normal! zo
617
normal! zo
617
normal! zo
618
normal! zo
620
normal! zo
626
normal! zo
632
normal! zo
639
normal! zo
645
normal! zo
658
normal! zo
659
normal! zo
667
normal! zo
680
normal! zo
682
normal! zo
686
normal! zo
689
normal! zo
693
normal! zo
733
normal! zo
735
normal! zo
739
normal! zo
742
normal! zo
745
normal! zo
764
normal! zo
791
normal! zo
816
normal! zo
818
normal! zo
821
normal! zo
824
normal! zo
831
normal! zo
843
normal! zo
844
normal! zo
883
normal! zo
884
normal! zo
889
normal! zo
896
normal! zo
896
normal! zo
908
normal! zo
914
normal! zo
920
normal! zo
923
normal! zo
927
normal! zo
927
normal! zo
928
normal! zo
930
normal! zo
936
normal! zo
936
normal! zo
937
normal! zo
939
normal! zo
945
normal! zo
947
normal! zo
949
normal! zo
951
normal! zo
957
normal! zo
964
normal! zo
966
normal! zo
968
normal! zo
984
normal! zo
987
normal! zo
990
normal! zo
992
normal! zo
997
normal! zo
999
normal! zo
1001
normal! zo
1003
normal! zo
1006
normal! zo
1009
normal! zo
1011
normal! zo
1030
normal! zo
1040
normal! zo
1050
normal! zo
1055
normal! zo
1064
normal! zo
1073
normal! zo
1075
normal! zo
1085
normal! zo
1090
normal! zo
1097
normal! zo
1111
normal! zo
1113
normal! zo
1115
normal! zo
1117
normal! zo
1119
normal! zo
1125
normal! zo
1131
normal! zo
1138
normal! zo
let s:l = 1 - ((0 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
tabedit lang_cpp/parsing/ast_cpp.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
95
normal! zo
153
normal! zo
189
normal! zo
194
normal! zo
230
normal! zo
283
normal! zo
304
normal! zo
304
normal! zo
376
normal! zo
419
normal! zo
455
normal! zo
474
normal! zo
474
normal! zo
476
normal! zo
482
normal! zo
495
normal! zo
505
normal! zo
510
normal! zo
535
normal! zo
550
normal! zo
551
normal! zo
569
normal! zo
571
normal! zo
573
normal! zo
580
normal! zo
580
normal! zo
591
normal! zo
614
normal! zo
631
normal! zo
638
normal! zo
640
normal! zo
653
normal! zo
732
normal! zo
807
normal! zo
let s:l = 149 - ((28 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
149
normal! 017|
tabedit h_program-lang/parse_info.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
58
normal! zo
58
normal! zo
79
normal! zo
550
normal! zo
552
normal! zo
let s:l = 584 - ((20 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
584
normal! 05|
tabedit commons/ocaml.ml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
339
normal! zo
340
normal! zo
342
normal! zo
353
normal! zo
353
normal! zo
354
normal! zo
370
normal! zo
370
normal! zo
373
normal! zo
387
normal! zo
let s:l = 368 - ((45 * winheight(0) + 23) / 46)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
368
normal! 0
tabnext 4
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
