local M = {
  "brenoprata10/nvim-highlight-colors",
  init = function()
    -- Ensure termguicolors is enabled if not already
    vim.opt.termguicolors = true
  end,
  config = function()
    require("nvim-highlight-colors").setup({})
  end,
}

return M
