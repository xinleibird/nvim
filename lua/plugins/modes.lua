---@module "lazy"
---@type LazySpec
local M = {
  "mvllow/modes.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  opts = function()
    return {
      line_opacity = 0.15,
      set_cursorline = false,
      ignore = {
        "lspinfo",
        "checkhealth",
        "help",
        "man",
        "!snacks_picker_list",
        "!snacks_picker_input",
        "!codecompanion",
        "Outline",
      },
    }
  end,

  config = function(_, opts)
    require("modes").setup(opts)
  end,
}

return M
