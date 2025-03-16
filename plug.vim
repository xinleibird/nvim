call plug#begin()
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
call plug#end()

set runtimepath-=~/.local/share/nvim/site/after

set guicursor=n-v:block,i-c-ci-ve:ver25,r-cr:hor20

augroup RestoreCursorShapeOnExit
  autocmd!
  autocmd VimLeave * set guicursor= | call chansend(v:stderr, "\x1b[ q")
augroup END
