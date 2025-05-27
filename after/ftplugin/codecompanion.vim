setlocal wrap

lua << EOF
vim.treesitter.language.register("markdown", { "codecompanion" })
EOF
