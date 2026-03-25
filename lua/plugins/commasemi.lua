---@module "lazy"
---@type LazySpec
local M = {
  "saifulapm/commasemi.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  init = function()
    vim.keymap.set({ "n", "i", "v" }, "<C-,>", function()
      if vim.bo[0].buftype == "" then
        vim.cmd.CommaToggle()
      end
    end, { desc = "Toggle , at eol" })
    vim.keymap.set({ "n", "i", "v" }, "<C-;>", function()
      if vim.bo[0].buftype == "" then
        vim.cmd.SemiToggle()
      end
    end, { desc = "Toggle ; at eol" })
  end,
  opts = {
    keymaps = false,
    commands = true,
  },
}

return M
