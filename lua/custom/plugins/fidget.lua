local icons = require("core.configs.icons")
local M = {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    progress = {
      display = {
        render_limit = 16, -- How many LSP messages to show at once
        done_ttl = 1, -- How long a message should persist after completion
        done_icon = icons.ui.CheckBold, -- Icon shown when all LSP progress tasks are complete
      },
    },
  },
}
return M