---@module "lazy"
---@type LazySpec
local M = {
  "danymat/neogen",
  event = { "BufRead", "User SnacksDashboardClosed" },
  config = function()
    ---@type neogen.Configuration
    require("neogen").setup({})
    vim.keymap.set("n", "<Leader>n", function()
      require("neogen").generate()
    end, { desc = "Generate annotations" })
  end,
}

return M
