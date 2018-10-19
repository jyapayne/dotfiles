let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Projects/desking-tool/desking
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 opportunities/static/js/components/BillOfSaleSettings.jsx
badd +1 pitch/views.py
badd +149 opportunities/templates/settings.html
badd +345 opportunities/views/ajax.py
badd +63 pitch/utils/bill_of_sale.py
badd +1 opportunities/static/js/components/Appraisal/AppraisalContainer.jsx
badd +411 opportunities/managers.py
badd +63 services/appraisal.py
badd +1 ~/Projects/desking-tool/docker-compose.test.yml
badd +43 ~/Projects/desking-tool/docker-compose.yml
badd +1 opportunities/static/js/components/Pitch/TradeInVehicleContainer.jsx
badd +1 opportunities/static/js/components/Pitch/Pitch.jsx
badd +1 opportunities/static/js/components/Pitch/PitchContainer.jsx
badd +266 opportunities/templates/opportunity-details.html
badd +51 customers/models.py
badd +97 pitch/models.py
badd +31 services/crm.py
badd +1 ~/Projects/desking-tool/Dockerfile
badd +1 ~/Projects/market-crm/Dockerfile
badd +38 opportunities/templates/detail-lead.html
badd +99 opportunities/static/js/opportunity.js
badd +90 services/lead.py
badd +38 ~/Projects/go-ops/desking-tool/docker-compose.yml
badd +356 customers/views.py
badd +681 customers/managers.py
badd +326 services/opportunity.py
badd +0 opportunities/static/js/modules/deallog/components/Table/Checklist/index.jsx
argglobal
silent! argdel *
$argadd opportunities/templates/detail-lead.html
edit opportunities/static/js/modules/deallog/components/Table/Checklist/index.jsx
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
let s:l = 1 - ((0 * winheight(0) + 42) / 85)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
tabnext 1
if exists('s:wipebuf')
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
