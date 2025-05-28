if exists('b:current_syntax')
  finish
endif

syn match QfFileName /^[^│]*/ nextgroup=qfSeparatorLeft
syn match QfSeparatorLeft /│/ contained nextgroup=qfLineNr
syn match QfLineNr /[^│]*/ contained nextgroup=qfSeparatorRight
syn match QfSeparatorRight '│' contained nextgroup=qfError,qfWarning,qfInfo,qfNote
syn match QfError / E .*$/ contained
syn match QfWarning / W .*$/ contained
syn match QfInfo / I .*$/ contained
syn match QfNote / [NH] .*$/ contained

hi def link QfFileName Directory
hi def link QfSeparatorLeft Delimiter
hi def link QfSeparatorRight Delimiter
hi def link QfLineNr LineNr
hi def link QfError DiagnosticError
hi def link QfWarning DiagnosticWarn
hi def link QfInfo DiagnosticInfo
hi def link QfNote DiagnosticHint

let b:current_syntax = 'qf'
