---@module "lazy"
---@type LazySpec
local M = {
  "kylechui/nvim-surround",
  event = { "BufRead", "User SnacksDashboardClosed" },
  config = function()
    require("nvim-surround").setup()
  end,
}

return M
