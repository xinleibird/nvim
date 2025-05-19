local M = {
  "saifulapm/commasemi.nvim",
  event = "BufEnter",
  init = function()
    vim.keymap.set({ "n", "i", "v" }, "<C-,>", vim.cmd.CommaToggle, { desc = "Buff diagnostics" })
    vim.keymap.set({ "n", "i", "v" }, "<C-;>", vim.cmd.SemiToggle, { desc = "Buff diagnostics" })
  end,
  opts = {
    keymaps = false,
    commands = true,
  },
}
return M
