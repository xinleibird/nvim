---@module "lazy"
---@type LazySpec
local M = {
  "folke/ts-comments.nvim",
  event = { "BufRead", "User SnacksDashboardClosed" },
  opts = {},
}

return M
