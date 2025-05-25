local M = {
  "Wansmer/treesj",
  event = "BufRead",
  -- keys = { "<leader>tt", "<leader>ta", "<leader>tR" },
  dependencies = "nvim-treesitter/nvim-treesitter",
  -- enabled = false,
  config = function()
    require("treesj").setup({})
    vim.keymap.set("n", "<leader>ta", require("treesj").toggle, { desc = "TS toggle" })
    vim.keymap.set("n", "<leader>tM", function()
      require("treesj").join({
        split = {
          recursive = true,
        },
      })
    end, { desc = "TS split recursive" })
    vim.keymap.set("n", "<leader>tR", function()
      require("treesj").split({ split = { recursive = true } })
    end, { desc = "TS join recursive" })
  end,
}

return M
