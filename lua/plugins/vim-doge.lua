local M = {
  "kkoomen/vim-doge",
  build = ":call doge#install()",
  event = "BufReadPre",
  init = function()
    vim.g.doge_mapping = "<leader>nn"
  end,
}

return M
