---@module "lazy"
---@type LazySpec
local M = {
  "kylechui/nvim-surround",
  event = "BufEnter *.*",
  config = function()
    require("nvim-surround").setup()
  end,
}

return M
