local M = {
  "kylechui/nvim-surround",
  event = "BufRead",
  config = function()
    require("nvim-surround").setup()
  end,
}

return M
