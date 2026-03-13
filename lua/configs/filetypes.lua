vim.filetype.add({
  pattern = {
    [".*/themes/catppuccin-.*"] = "conf",
    [".*/.vscode/launch.json"] = "jsonc",
  },
})
