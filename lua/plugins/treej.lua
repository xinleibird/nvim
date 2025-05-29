local M = {
  "Wansmer/treesj",
  event = "BufRead",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })
    vim.keymap.set("n", "<leader>ta", require("treesj").toggle, { desc = "TreeSitter toggle" })
    vim.keymap.set("n", "<leader>tM", function()
      require("treesj").join({
        split = {
          recursive = true,
        },
      })
    end, { desc = "TreeSitter split recursive" })
    vim.keymap.set("n", "<leader>tR", function()
      require("treesj").split({ split = { recursive = true } })
    end, { desc = "TreeSitter join recursive" })

    vim.api.nvim_del_user_command("TSJToggle")
    vim.api.nvim_del_user_command("TSJSplit")
    vim.api.nvim_del_user_command("TSJJoin")
  end,
}

return M
