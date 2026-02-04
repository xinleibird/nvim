local M = {
  "kylechui/nvim-surround",
  -- TODO: BufEnter
  event = "BufEnter *.*",
  config = function()
    require("nvim-surround").setup()
  end,
}

return M
