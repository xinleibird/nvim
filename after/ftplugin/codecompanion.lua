vim.opt_local.wrap = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2

vim.b.indent_guide = false

vim.wo.winhighlight = "NormalFloat:CodeCompanionNormal,FloatBorder:CodeCompanionBorder"

local win_config = vim.api.nvim_win_get_config(0)
if win_config.relative ~= "" then
  vim.keymap.set({ "n", "t", "i" }, "<C-h>", "", { silent = true, buffer = true })
  vim.keymap.set({ "n", "t", "i" }, "<C-l>", "", { silent = true, buffer = true })
  vim.keymap.set({ "n", "t", "i" }, "<C-j>", "", { silent = true, buffer = true })
  vim.keymap.set({ "n", "t", "i" }, "<C-k>", "", { silent = true, buffer = true })
end

vim.keymap.set("n", "<leader>q", function()
  vim.cmd("close")
end, { desc = "Quit", buffer = true, silent = true, nowait = true })
