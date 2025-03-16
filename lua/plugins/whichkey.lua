local M = {
  "folke/which-key.nvim",
  keys = { "<leader>", "<c-r>", '"', "'", "g" },
  lazy = false,
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
        group = "Translate",
        icon = "󰗊",
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
        group = "NeoTree toggle",
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
        "<C-w>",
        group = "Diagnostics",
        icon = "",
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
        "c",
        group = "Clear insert",
        icon = "󱂨",
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
        "s",
        group = "Flash",
        icon = "󰻹",
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
        "<leader>sz",
        icon = "󰊄",
      },
      {
        "z",
        icon = "",
        group = "Fold",
      },
      {
        "s",
        icon = "󱖲",
      },
      {
        "<C-s>",
        icon = "󱖳",
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
    })

    require("which-key").setup({
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
          windows = false, -- default bindings on <c-w>
          nav = false, -- misc bindings to work with windows
          z = false, -- bindings for folds, spelling and others prefixed with z
          g = false, -- bindings for prefixed with g
        },
      },
    })
  end,
}

return M
