let mapleader=' '
let g:qs_highlight_on_keys=['f', 'F', 't', 'T']
let g:qs_hi_priority = 2

highlight QuickScopePrimary guifg='#EC1424' gui=underline ctermfg=196 cterm=underline
highlight QuickScopeSecondary guifg='#6F0008' gui=underline ctermfg=52 cterm=underline

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

nnoremap <silent> ? <CMD>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>
nnoremap <silent> z= <CMD>call VSCodeNotify('keyboard-quickfix.openQuickFix')<CR>

nmap <silent> <leader>lj <CMD>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>
nmap <silent> <leader>lk <CMD>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>

nmap <leader>e <CMD>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
