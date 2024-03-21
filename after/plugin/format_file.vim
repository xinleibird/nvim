function! s:Preserve(command) abort
  " Save the last search.
  let search = @/

  " Save the current cursor position.
  let cursor_position = getpos('.')

  " Save the current window position.
  normal! H
  let window_position = getpos('.')
  call setpos('.', cursor_position)

  " Execute the command.
  execute a:command

  " Restore the last search.
  let @/ = search

  " Restore the previous window position.
  call setpos('.', window_position)
  normal! zt

  " Restore the previous cursor position.
  call setpos('.', cursor_position)
endfunction

" Re-indent the whole buffer.
function! s:Indent() abort
  call s:Preserve('normal gg=G')
endfunction

function! s:Spaces() abort
  call s:Preserve('silent! %s/\s\+$//e')
endfunction

function! s:EndLines() abort
  call s:Preserve('silent! %s#\($\n\s*\)\+\%$##')
endfunction

function FormatFile() abort
  call s:Spaces()
  call s:EndLines()
  call s:Indent()
endfunction
