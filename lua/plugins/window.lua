local M = {
  "yorickpeterse/nvim-window",
  event = "VimEnter",
  init = function()
    vim.keymap.set("n", "<leader>wj", function()
      require("nvim-window").pick()
    end, { desc = "Windows jump" })
    vim.keymap.set("n", ",", function()
      require("nvim-window").pick()
    end, { desc = "Windows jump" })
  end,

  config = true,
}

return M
