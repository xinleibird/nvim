local M = {
  "togglesemi",
  event = "BufRead",
  dir = vim.fn.stdpath("config") .. "/lua/custom/packages/togglesemi",
  config = function()
    require("togglesemi").setup()
  end,
}

return M
