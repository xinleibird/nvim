local M = {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua", -- optional
  },
  event = "VimEnter",
  init = function()
    vim.keymap.set("n", "<leader>gg", function()
      local ok, neogit = pcall(require, "neogit")
      if ok then
        neogit.open()
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
      end,
    })
  end,
}

return M
