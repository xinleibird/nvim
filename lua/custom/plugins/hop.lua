local M = {
  "smoka7/hop.nvim",
  event = "VimEnter",
  config = function()
    local hop = require("hop")

    hop.setup()

    vim.keymap.set("n", "s", function()
      require("hop").hint_words({})
    end, { remap = true, silent = true, desc = "Hop [s] motion " })

    -- local directions = require("hop.hint").HintDirection
    --
    -- vim.keymap.set("", "f", function()
    --   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    -- end, { remap = true, silent = true, desc = "Hop [f] motion" })
    --
    -- vim.keymap.set("", "F", function()
    --   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    -- end, { remap = true, silent = true, desc = "Hop [F] motion" })
    --
    -- vim.keymap.set("", "t", function()
    --   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    -- end, { remap = true, silent = true, desc = "Hop [t] motion" })
    --
    -- vim.keymap.set("", "T", function()
    --   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
    -- end, { remap = true, silent = true, desc = "Hop [T] motion" })
  end,
}

return M
