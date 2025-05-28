setlocal wrap
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

let b:snacks_scope=v:false

lua << EOF
vim.treesitter.language.register("markdown", { "codecompanion" })
EOF
