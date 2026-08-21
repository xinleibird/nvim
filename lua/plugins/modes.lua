---@module "lazy"
---@type LazySpec
local M = {
  "mvllow/modes.nvim",
  commit = "2badf8771dbb2d1e1066fd6a5dddaad2fc836e72",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  opts = function()
    return {
      line_opacity = 0.30,
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
