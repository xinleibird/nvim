vim.schedule(function()
  vim.keymap.set("n", "<Esc>", "<Nop>", { buffer = true, silent = true, nowait = true })
end)
