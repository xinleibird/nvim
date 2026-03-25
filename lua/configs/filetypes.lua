vim.filetype.add({
  pattern = {
    [".*/ghostty/themes/.*"] = "conf",
    [".*/.zsh_plugins.txt"] = "conf",
    [".*/.vscode/launch.json"] = "jsonc",
  },
})
