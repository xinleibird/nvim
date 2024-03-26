local M = {
  "NeogitOrg/neogit",
  event = "FileReadPre",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
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
  end,
}

return M
