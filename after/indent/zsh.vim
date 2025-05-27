" setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
" setlocal indentexpr=v:lua.require'nvim-treesitter'.indentexpr()

lua << EOF
vim.treesitter.language.register("bash", { "zsh" })
EOF
