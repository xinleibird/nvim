local M = {
  "viml-auto-indent",
  event = "BufRead",
  dir = vim.fn.stdpath("config") .. "/lua/custom/packages/viml-auto-indent",
}

return M
