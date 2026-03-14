---@module "lazy"
---@type LazySpec
local M = {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      options = {
        override_open_float = true,
      },
    })
  end,
}

return M
