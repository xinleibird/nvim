local M = {
  "dmmulroy/tsc.nvim",
  event = "BufRead",
  config = function()
    require("tsc").setup()
  end,
}

return M
