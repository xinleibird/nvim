---@module "lazy"
---@type LazySpec
local M = {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    left = {
      {
        title = "DAP Scopes",
        ft = "dapui_scopes",
        size = { height = 0.25 },
      },
      {
        title = "DAP Breakpoints",
        ft = "dapui_breakpoints",
        size = { height = 0.25 },
      },
      {
        title = "DAP Stacks",
        ft = "dapui_stacks",
        size = { height = 0.25 },
      },
      {
        title = "DAP Watches",
        ft = "dapui_watches",
        size = { height = 0.25 },
      },
    },
    top = {
      {
        title = "DAP Repl",
        ft = "dapui_repl",
        size = { height = 0.25 },
      },
      -- {
      --   title = "DAP Console",
      --   ft = "dapui_console",
      --   size = { height = 0.25 },
      -- },
    },
    bottom = {
      {
        ft = "toggleterm",
        title = " term %{b:toggle_number}",
        size = { height = 0.4 },
        filter = function(_, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      },
    },
    options = {
      left = { size = 0.2 },
      right = { size = 30 },
    },
    icons = {
      closed = require("configs.icons").ui.ArrowClosed,
      open = require("configs.icons").ui.ArrowOpen,
    },
    animate = {
      enabled = false,
    },
  },
}

return M
