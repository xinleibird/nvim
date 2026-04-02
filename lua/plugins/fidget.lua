---@module "lazy"
---@type LazySpec
local M = {
  "j-hui/fidget.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  opts = {
    progress = {
      display = {
        done_ttl = 2, -- How long a message should persist after completion
        done_icon = require("configs.icons").ui.CheckBold, -- Icon shown when all LSP progress tasks are complete
        progress_icon = { pattern = "circle_halves", period = 1 },
      },
    },
    notification = {
      window = {
        winblend = 100,
      },
    },
  },
}

return M
