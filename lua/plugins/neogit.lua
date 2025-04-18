local M = {
  "NeogitOrg/neogit",
  event = "FileReadPre",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua", -- optional
  },
  init = function()
    vim.keymap.set("n", "<leader>gg", function()
      local ok, neogit = pcall(require, "neogit")
      if ok then
        neogit.open({ kind = "tab" })
      end
    end, { desc = "Neogit" })
  end,
  config = function()
    local icons = require("configs.icons").ui
    require("neogit").setup({
      signs = {
        -- { CLOSED, OPENED }
        hunk = { "", "" },
        item = { icons.ArrowClosed, icons.ArrowOpen },
        section = { icons.ArrowClosed, icons.ArrowOpen },
      },
    })

    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("user_neogit_refresh_neotree", { clear = true }),
      pattern = "NeogitStatusRefreshed",
      desc = "Handle git events for neo-tree",
      callback = function()
        require("neo-tree.sources.filesystem.commands").refresh(
          require("neo-tree.sources.manager").get_state("filesystem")
        )
        vim.defer_fn(function()
          local wins = vim.api.nvim_list_wins()
          for _, w in ipairs(wins) do
            local b = vim.api.nvim_win_get_buf(w)
            if vim.bo[b].filetype == "NeogitStatus" then
              vim.api.nvim_set_current_win(w)
              return
            end
          end
        end, 100)
      end,
    })
  end,
}

return M
