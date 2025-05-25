local M = {
  "echasnovski/mini.diff",
  event = "BufRead",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        local notify = function()
          vim.notify("Please git init your project directory first!", vim.log.levels.WARN, { title = "mini-diff" })
        end
        if Snacks.git.get_root() == nil then
          vim.keymap.set("n", "<leader>gd", notify, { silent = true, buffer = true })
          vim.keymap.set("n", "<leader>gj", notify, { silent = true, buffer = true })
          vim.keymap.set("n", "<leader>gk", notify, { silent = true, buffer = true })
          vim.keymap.set("n", "[g", notify, { silent = true, buffer = true })
          vim.keymap.set("n", "]g", notify, { silent = true, buffer = true })
        end
      end,
    })
  end,
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
