vim.filetype.add({
  pattern = {
    [".*/themes/catppuccin-.*"] = "ghostty",
    [".*/.vscode/launch.json"] = "jsonc",
  },
})
