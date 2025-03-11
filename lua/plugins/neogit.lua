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

    local events = require("neo-tree.events")
    events.fire_event(events.GIT_EVENT)
  end,
}

return M
