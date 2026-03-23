---@module "lazy"
---@type LazySpec
local M = {
  "kylechui/nvim-surround",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  config = function()
    require("nvim-surround").setup()
  end,
}

return M
