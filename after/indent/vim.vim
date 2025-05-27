augroup VimLAutoFormat
  autocmd!
  autocmd BufWritePre <buffer> call FormatFile()
augroup END

" setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
" setlocal indentexpr=v:lua.require'nvim-treesitter'.indentexpr()
