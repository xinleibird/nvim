local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufRead",
  init = function()
    vim.keymap.set("n", "<leader>go", "<cmd>Telescope git_status<CR>", { desc = "Git status" })

    vim.keymap.set("n", "<leader>gj", function()
      vim.schedule(function()
        require("gitsigns").nav_hunk("next")
      end)
    end, { desc = "Next hunk", expr = true })

    vim.keymap.set("n", "<leader>gk", function()
      vim.schedule(function()
        require("gitsigns").nav_hunk("prev")
      end)
    end, { desc = "Prev hunk", expr = true })

    vim.keymap.set("n", "[g", function()
      if vim.wo.diff then
        return "[g"
      end
      vim.schedule(function()
        require("gitsigns").nav_hunk("prev")
      end)
      return "<Ignore>"
    end, { desc = "Prev hunk", expr = true })

    vim.keymap.set("n", "]g", function()
      if vim.wo.diff then
        return "]g"
      end
      vim.schedule(function()
        require("gitsigns").nav_hunk("next")
      end)
      return "<Ignore>"
    end, { desc = "Next hunk", expr = true })

    vim.keymap.set("n", "<leader>gb", function()
      package.loaded.gitsigns.blame_line()
    end, { desc = "Blame line", expr = true })

    vim.keymap.set("n", "<leader>gd", function()
      require("gitsigns").diffthis("", { split = "belowright" })
    end, { desc = "Diff this", expr = true })
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
