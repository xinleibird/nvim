augroup VimLAutoFormat
  autocmd!
  autocmd BufWritePre <buffer> call FormatFile()
augroup END
