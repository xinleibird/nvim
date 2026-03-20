---@module "lazy"
---@type LazySpec
local M = {
  "acidsugarx/babel.nvim",
  version = "*", -- recomended for the latest tag, not main
  event = { "BufRead", "User SnacksDashboardClosed" },
  opts = {
    target = "zh-CN", -- target language
    -- display = "picker", -- "float" or "picker"
    -- picker = "snacks", -- "auto", "telescope", "fzf", "snacks", "mini"
    keymaps = {
      translate = "<leader>tt",
      translate_word = "<leader>tt",
    },
  },
  config = function(_, opts)
    require("babel").setup(opts)
  end,
}

return M
