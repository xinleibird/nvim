---@type vim.lsp.Config
return {
  settings = {
    bashIde = {
      globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command|.zsh)",
    },
  },
  filetypes = { "bash", "sh", "zsh" },
  single_file_support = true,
}
