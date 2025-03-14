local M = {
  "jinh0/eyeliner.nvim",
  event = "VeryLazy",
  config = function()
    require("eyeliner").setup({
      highlight_on_key = true, -- this must be set to true for dimming to work!
      dim = true,
      disabled_filetypes = { "neo-tree", "alpha" },
      disabled_buftypes = { "nofile" },
    })
  end,
}

return M
