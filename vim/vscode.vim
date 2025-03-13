xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

nnoremap <silent> ? <CMD>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>
nnoremap <silent> z= <CMD>call VSCodeNotify('keyboard-quickfix.openQuickFix')<CR>

nmap <silent> <leader>lj <CMD>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>
nmap <silent> <leader>lk <CMD>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>

nmap <leader>e <CMD>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
