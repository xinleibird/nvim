local M = {
  "xinleibird/neogen",
  name = "neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    require("neogen").setup({
      enabled = true,
      input_after_comment = true,
      snippet_engine = "nvim",
    })
  end,
  init = function()
    vim.keymap.set("n", "<leader>nn", ":Neogen<CR>", { noremap = true, silent = true })
  end,
  -- load only when needed to improve startup speed
  cmd = "Neogen",
}

return M
