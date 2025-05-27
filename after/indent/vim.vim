augroup VimLAutoFormat
  autocmd!
  autocmd BufWritePre <buffer> call FormatFile()
augroup END

" setlocal indentexpr=v:lua.require'nvim-treesitter'.indentexpr()
