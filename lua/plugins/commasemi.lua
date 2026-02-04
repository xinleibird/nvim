local M = {
  "saifulapm/commasemi.nvim",
  event = "BufEnter *.*",
  init = function()
    vim.keymap.set({ "n", "i", "v" }, "<C-,>", function()
      if vim.bo[0].buftype == "" then
        vim.cmd.CommaToggle()
      end
    end, { desc = "Buff diagnostics" })
    vim.keymap.set({ "n", "i", "v" }, "<C-;>", function()
      if vim.bo[0].buftype == "" then
        vim.cmd.SemiToggle()
      end
    end, { desc = "Buff diagnostics" })
  end,
  opts = {
    keymaps = false,
    commands = true,
  },
}
return M
