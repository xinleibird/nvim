local M = {
  "ofirgall/open.nvim",
  event = "BufRead",
  dependencies = "nvim-lua/plenary.nvim",
  init = function()
    vim.keymap.set("n", "gx", require("open").open_cword, { desc = "Open URI" })
  end,
  config = function()
    require("open").setup({})
  end,
}

return M
