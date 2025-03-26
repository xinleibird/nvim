---@diagnostic disable: missing-fields
local M = {
  "smoka7/hop.nvim",
  event = "VimEnter",
  init = function()
    local hop = require("hop")
    local position = require("hop.hint").HintPosition
    vim.keymap.set("n", "s", function()
      hop.hint_char1({
        hint_position = position.MIDDLE,
      })
    end, { remap = true, silent = true, desc = "Hop [s] motion " })

    vim.keymap.set("n", "S", function()
      local hop_treesitter = require("hop-treesitter")
      if vim.treesitter.language.get_lang(vim.bo.filetype) then
        hop_treesitter.hint_nodes({
          hint_position = position.MIDDLE,
        })
      else
        vim.notify(" No parser for this file!", vim.log.levels.WARN, { title = "TreeSitter" })
      end
    end, { remap = true, silent = true, desc = "Hop [S] motion " })

    local directions = require("hop.hint").HintDirection

    vim.keymap.set("", "f", function()
      hop.hint_char1({
        direction = directions.AFTER_CURSOR,
        current_line_only = true,
        hint_position = position.MIDDLE,
      })
    end, { remap = true, silent = true, desc = "Hop [f] motion" })

    vim.keymap.set("", "F", function()
      hop.hint_char1({
        direction = directions.BEFORE_CURSOR,
        current_line_only = true,
        hint_position = position.MIDDLE,
      })
    end, { remap = true, silent = true, desc = "Hop [F] motion" })

    vim.keymap.set("", "t", function()
      hop.hint_char1({
        direction = directions.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1,
        hint_position = position.MIDDLE,
      })
    end, { remap = true, silent = true, desc = "Hop [t] motion" })

    vim.keymap.set("", "T", function()
      hop.hint_char1({
        direction = directions.BEFORE_CURSOR,
        current_line_only = true,
        hint_offset = 1,
        hint_position = position.MIDDLE,
      })
    end, { remap = true, silent = true, desc = "Hop [T] motion" })
  end,

  config = function()
    require("hop").setup()
  end,
}

return M
