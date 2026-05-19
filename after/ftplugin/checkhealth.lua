vim.keymap.set("n", "q", "<cmd>bd<CR>", { buffer = true, silent = true, nowait = true })
vim.keymap.set({ "n", "x" }, "<leader>q", "<cmd>bd<CR>", { buffer = true, silent = true, nowait = true })
