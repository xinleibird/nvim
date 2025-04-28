local M = {
  "echasnovski/mini.diff",
  event = "VeryLazy",
  keys = {
    {
      "<leader>gd",
      function()
        require("mini.diff").toggle_overlay(0)
      end,
      desc = "Diff this",
    },
    {
      "<leader>gj",
      function()
        require("mini.diff").goto_hunk("next", { wrap = true })
      end,
      desc = "Next hunk",
    },
    {
      "<leader>gk",
      function()
        require("mini.diff").goto_hunk("prev", { wrap = true })
      end,
      desc = "Prev hunk",
    },
    {
      "]g",
      function()
        require("mini.diff").goto_hunk("next", { wrap = true })
      end,
      desc = "Next hunk",
    },
    {
      "[g",
      function()
        require("mini.diff").goto_hunk("prev", { wrap = true })
      end,
      desc = "Prev hunk",
    },
  },
  opts = {
    view = {
      style = "sign",
      signs = {
        add = "▎",
        change = "▎",
        delete = "",
      },
    },
    mappings = {
      apply = "<leader>ga",
      reset = "<leader>gr",
      -- Works also in Visual mode if mapping differs from apply and reset
      textobject = "",
    },
  },
}

return M
