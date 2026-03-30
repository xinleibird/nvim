---@module "lazy"
---@type LazySpec
local M = {
  "mvllow/modes.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardflavourlosed" },
  config = function()
    require("modes").setup({
      line_opacity = 0.15,
      set_cursorline = false,
    })
  end,
}

return M
