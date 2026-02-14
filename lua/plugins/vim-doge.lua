local M = {
  "kkoomen/vim-doge",
  build = ":call doge#install()",
  event = "BufWinEnter",
  init = function()
    vim.g.doge_mapping = "<leader>nn"
    vim.g.doge_javascript_settings = {
      destructuring_props = 1,
      omit_redundant_param_types = 1,
    }
  end,
}

return M
