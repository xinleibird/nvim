local M = {
  "viml-auto-indent",
  event = "BufRead",
  dir = vim.fn.stdpath("config") .. "/packages/viml-auto-indent",
}

return M
