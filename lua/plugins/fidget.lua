local M = {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    notification = {
      window = {
        winblend = 0,
      },
    },
    progress = {
      display = {
        render_limit = 16, -- How many LSP messages to show at once
        done_ttl = 1, -- How long a message should persist after completion
        done_icon = require("configs.icons").ui.CheckBold, -- Icon shown when all LSP progress tasks are complete
        progress_icon = { pattern = "circle_halves", period = 1 },
      },
    },
  },
}

return M
