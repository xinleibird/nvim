local M = {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "nvim-telescope/telescope.nvim", -- optional
    -- "ibhagwan/fzf-lua", -- optional
  },
  event = "VimEnter",
  config = function()
    local icons = require("core.configs.icons").ui
    require("neogit").setup({
      signs = {
        -- { CLOSED, OPENED }
        hunk = { "", "" },
        item = { icons.ArrowClosed, icons.ArrowOpen },
        section = { icons.ArrowClosed, icons.ArrowOpen },
      },
    })
  end,
}

return M
