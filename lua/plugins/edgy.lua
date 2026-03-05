local M = {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    left = {
      {
        title = "DAP Scopes",
        ft = "dapui_scopes",
        size = { height = 0.35 },
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
        size = { height = 0.25 },
      },
    },
    bottom = {
      {
        title = "DAP Repl",
        ft = "dapui_repl",
        wo = { winfixwidth = true },
      },
      -- {
      --   title = "DAP Console",
      --   ft = "dapui_console",
      --   size = { height = 0.2 },
      --   wo = { winfixwidth = true },
      -- },
      {
        ft = "toggleterm",
        title = " term %{b:toggle_number}",
        size = { height = 0.4 },
        filter = function(_, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
        wo = {
          winhighlight = "Normal:Normal,NormalNC:NormalNC",
        },
      },
    },
  },
}

return M
