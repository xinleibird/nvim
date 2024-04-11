local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufRead",
  init = function()
    vim.keymap.set("n", "<leader>go", "<cmd>Telescope git_status<CR>", { desc = "Search changed files" })

    vim.keymap.set("n", "<leader>gj", function()
      require("gitsigns").next_hunk()
    end, { desc = "Jump to next hunk", expr = true })

    vim.keymap.set("n", "<leader>gk", function()
      require("gitsigns").prev_hunk()
    end, { desc = "Jump to prev hunk", expr = true })

    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        require("gitsigns").next_hunk()
      end)
      return "<Ignore>"
    end, { desc = "Jump to next hunk", expr = true })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        require("gitsigns").prev_hunk()
      end)
      return "<Ignore>"
    end, { desc = "Jump to prev hunk", expr = true })

    vim.keymap.set("n", "<leader>gb", function()
      package.loaded.gitsigns.blame_line()
    end, { desc = "Blame line", expr = true })

    vim.keymap.set("n", "<leader>gd", function()
      require("gitsigns").diffthis("", { split = "belowright" })
    end, { desc = "Diff this file", expr = true })
  end,
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "┊" },
        untracked = { text = "│" },
      },

      on_attach = function() end,
    })
  end,
}

return M
