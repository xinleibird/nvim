local M = {
  "ggandor/flit.nvim",
  lazy = false,
  dependencies = {
    {
      "https://codeberg.org/andyg/leap.nvim",
      init = function()
        vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
        vim.keymap.set({ "x", "o" }, "R", function()
          require("leap.treesitter").select({
            opts = require("leap.user").with_traversal_keys("R", "r"),
          })
        end)
      end,
    },
    "tpope/vim-repeat",
  },
  config = function()
    require("flit").setup()
  end,
}

return M
