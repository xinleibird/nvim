vim.keymap.set("n", "<leader>q", function()
  vim.cmd("close")
end, { desc = "Quit", buffer = true, silent = true, nowait = true })
