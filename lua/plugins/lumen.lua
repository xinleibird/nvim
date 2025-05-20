local M = {
  -- make sure install this, it guarantees that vim.o.background can be obtained quickly
  -- and that some GUI programs can obtain background values.
  -- https://github.com/neovim/neovim/pull/31350, neovim v10 supported, but not perfect.
  "vimpostor/vim-lumen",
  lazy = false,
}

return M
