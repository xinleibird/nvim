---@module "lazy"
---@type LazySpec
local M = {
  "neovim/nvim-lspconfig",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
}

return M
