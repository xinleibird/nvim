local M = {
  "nacro90/numb.nvim",
  event = "BufRead",
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("numb").setup({
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
    })
  end,
}

return M
