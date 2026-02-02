local M = {
  "acidsugarx/babel.nvim",
  version = "*", -- recomended for the latest tag, not main
  lazy = false,
  opts = {
    target = "zh-CN", -- target language
    -- display = "picker", -- "float" or "picker"
    -- picker = "snacks", -- "auto", "telescope", "fzf", "snacks", "mini"
    keymaps = {
      translate = "<leader>tt",
      translate_word = "<leader>tt",
    },
  },
}

return M
