---@module "lazy"
---@type LazySpec
local M = {
  "mvllow/modes.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed", "User SnacksDashboardOpened" },
  config = function()
    require("modes").setup({
      line_opacity = 0.15,
      set_cursorline = false,
      -- Disable modes highlights for specified filetypes
      -- or enable with prefix "!" if otherwise disabled (please PR common patterns)
      -- Can also be a function fun():boolean that disables modes highlights when true
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
    })
  end,
}

return M
