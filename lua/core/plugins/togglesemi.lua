local M = {
  "togglesemi",
  event = "BufRead",
  dir = vim.fn.stdpath("config") .. "/packages/togglesemi",
  config = function()
    require("togglesemi").setup()
  end,
}

return M
