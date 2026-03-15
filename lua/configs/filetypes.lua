vim.filetype.add({
  pattern = {
    [".*/ghostty/themes/.*"] = "conf",
    [".*/.vscode/launch.json"] = "jsonc",
  },
})
