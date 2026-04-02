---@module "lazy"
---@type LazySpec
local M = {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    right = {
      {
        title = "    CodeCompanion Chat 💬",
        ft = "codecompanion",
        filter = function(_, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
        -- pinned = true,
      },
      {
        title = "    CodeCompanion CLI  🤖",
        ft = "codecompanion_cli",
        -- pinned = true,
      },
    },
    left = {
      {
        title = "Explorer",
        ft = "snacks_layout_box",
        -- exclude floating windows
        filter = function(_, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
        -- pinned = true,
      },
      {
        title = "DAP Scopes",
        ft = "dapui_scopes",
        size = { height = 0.25 },
      },
      {
        title = "DAP Stacks",
        ft = "dapui_stacks",
        size = { height = 0.25 },
      },
      {
        title = "DAP Breakpoints",
        ft = "dapui_breakpoints",
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
        ft = "dap-repl",
        width = 0.5,
      },
      {
        title = "DAP Console",
        ft = "dapui_console",
        width = 0.5,
      },
    },
    bottom = {
      {
        ft = "toggleterm",
        title = " term %{b:toggle_number}",
        filter = function(_, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      },
    },
    options = {
      left = { size = 28 },
      right = { size = 0.47 },
      top = { size = 0.23 },
      bottom = { size = 0.35 },
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
