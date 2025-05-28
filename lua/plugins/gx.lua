local M = {
  "chrishrb/gx.nvim",
  keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
  cmd = { "Browse" },
  dependencies = { "nvim-lua/plenary.nvim" }, -- Required for Neovim < 0.10.0
  init = function()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  config = true, -- default settings
  submodules = false, -- not needed, submodules are required only for tests
}

return M
