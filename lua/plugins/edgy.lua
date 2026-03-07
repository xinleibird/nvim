local M = {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    left = {
      {
        title = "DAP Scopes",
        ft = "dapui_scopes",
        size = { height = 0.2 },
      },
      {
        title = "DAP Breakpoints",
        ft = "dapui_breakpoints",
        size = { height = 0.2 },
      },
      {
        title = "DAP Stacks",
        ft = "dapui_stacks",
        size = { height = 0.2 },
      },
      {
        title = "DAP Watches",
        ft = "dapui_watches",
        size = { height = 0.2 },
      },
      {
        title = "DAP Console",
        ft = "dapui_console",
        size = { height = 0.2 },
      },
    },
    top = {
      {
        title = "DAP Repl",
        ft = "dapui_repl",
        size = { width = 0.5 },
      },
    },
    bottom = {
      {
        ft = "toggleterm",
        title = " term %{b:toggle_number}",
        size = { height = 0.4 },
        filter = function(_, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
        wo = {
          winhighlight = "Normal:Normal,NormalNC:NormalNC",
          winfixwidth = true,
          winfixheight = true,
        },
      },
    },
    options = {
      left = { size = 0.2 },
    },
    icons = {
      closed = require("configs.icons").ui.ArrowClosed,
      open = require("configs.icons").ui.ArrowOpen,
    },
  },
}

return M
