local M = {
  "folke/which-key.nvim",
  event = "ColorScheme",
  dependencies = "nvim-tree/nvim-web-devicons",
  keys = { "<leader>", "<c-r>", '"', "'", "g" },
  cmd = "WhichKey",
  config = function()
    local wk = require("which-key")
    wk.add({
      {
        "<leader>b",
        group = "Buffs",
        icon = "",
      },
      {
        "<leader>s",
        group = "Search",
        icon = "",
      },
      {
        "<leader>l",
        group = "LSP",
        icon = "󰿘",
      },
      {
        "<leader>g",
        group = "Git",
        icon = "",
      },
      {
        "<leader>t",
        group = "TS join/split",
        icon = "󰤼",
      },
      {
        "<leader>d",
        group = "Debug",
        icon = "󰨰",
      },
      {
        "<leader>w",
        group = "Save WITH formatting",
        icon = "",
      },
      {
        "<leader>W",
        group = "Save WITHOUT formatting",
        icon = "",
      },
      {
        "<leader>e",
        group = "Explorer toggle",
        icon = "󱂪",
      },
      {
        "<leader>o",
        group = "Outline toggle",
        icon = "󱂫",
      },
      {
        "<leader>",
        group = "Leader",
        icon = "",
      },
      {
        "[",
        group = "Jump prev",
        icon = "󱞧",
      },
      {
        "]",
        group = "Jump next",
        icon = "󱞫",
      },
      {
        "g",
        group = "General action",
        icon = "󰆾",
      },
      {
        "<F2>",
        group = "Rename",
        icon = "",
      },
      {
        "<ESC>",
        group = "Clear highlight",
        icon = "󱜟",
      },
      {
        "t",
        group = "To motion",
        icon = "",
      },
      {
        "T",
        group = "To (backward) motion",
        icon = "",
      },
      {
        "f",
        group = "Find motion",
        icon = "󰮺",
      },
      {
        "F",
        group = "Find (backward) motion",
        icon = "󰮹",
      },
      {
        "c",
        group = "Clear motion",
        icon = "",
      },
      {
        "d",
        group = "Delete normal",
        icon = "󱂨",
      },
      {
        "y",
        group = "Yank",
        icon = "",
      },
      {
        "<M-p>",
        group = "Move to prev reference",
        icon = "",
      },
      {
        "<M-n>",
        group = "Move to next reference",
        icon = "",
      },
      {
        "Y",
        icon = "",
      },
      {
        "&",
        icon = "󰮚",
      },
      {
        "z",
        icon = "",
        group = "Fold",
      },
      {
        "s",
        icon = "󱍂",
      },
      {
        "S",
        icon = "󱍂",
      },
      {
        "<C-q>",
        icon = "󱄲",
      },
      {
        "<C-`>",
        icon = "󱄲",
      },
      {
        "%",
        group = "Match",
        icon = "󱉸",
      },
      {
        "<D-j>",
        icon = "",
        group = "Toggle term",
      },
      {
        "<M-j>",
        icon = "",
        group = "Toggle term",
      },
      {
        "<C-w>",
        icon = "",
        group = "Windows",
      },
      {
        "<C-w>d",
        group = "Diagnostics under cursor",
      },
      {
        "<C-w><C-d>",
        group = "Diagnostics under cursor",
      },
      {
        ",",
        icon = "",
        group = "Windows jump",
      },
      {
        "<leader>a",
        icon = "󰊠",
        group = "Codecompanion",
      },
      {
        "<leader>sP",
        icon = "",
      },
      {
        "<C-,>",
        icon = ";",
        group = "Toggle Semi",
      },
      {
        "<C-;>",
        icon = ",",
        group = "Toggle Comma",
      },
      {
        "<D-v>",
        icon = "",
      },
      {
        "K",
        icon = "󰟶",
      },
      {
        "gx",
        icon = "",
        group = "Open it",
      },
    })

    ---@diagnostic disable-next-line: missing-fields
    require("which-key").setup({
      win = {
        height = { min = 4, max = 25 },
      },
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
          enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          Suggestions = 20, -- how many suggestions should be shown in the list?
        },
        presets = {
          operators = false, -- adds help for operators like d, y, ...
          motions = false, -- adds help for motions
          text_objects = false, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = false, -- misc bindings to work with windows
          z = false, -- bindings for folds, spelling and others prefixed with z
          g = false, -- bindings for prefixed with g
        },
      },
    })
  end,
}

return M
