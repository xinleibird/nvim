-- Let treesitter use bash highlight for zsh files as well
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  group = vim.api.nvim_create_augroup("user_zsh_highlight", { clear = true }),
  callback = function()
    local ok, highlight = pcall(require, "nvim-treesitter.highlight")
    if ok then
      highlight.attach(0, "bash")
    end
  end,
})

-- Leave nvim restore cursor style
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*",
  command = 'set guicursor= | call chansend(v:stderr, "\x1b[ q")',
})

-- Fixed qf repl win position and  height
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "dap-repl", "qf" },
--   group = vim.api.nvim_create_augroup("user_set_qf_repl_window", { clear = true }),
--   -- command = "wincmd K|setlocal winfixheight|setlocal nonumber",
--   command = "setlocal winfixheight|setlocal nonumber",
-- })

-- Set formatoptions
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("user_set_formatoptions", { clear = true }),
  command = "setlocal formatoptions-=o",
})

-- Close lazy buffer use <esc> and q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lazy" },
  group = vim.api.nvim_create_augroup("user_add_buf_quit_hotkey", { clear = true }),
  command = "nnoremap <buffer><silent> <Esc> <CMD>close!<CR>",
})

vim.api.nvim_create_autocmd({ "QuitPre" }, {
  callback = function()
    vim.cmd("Neotree close")
    vim.cmd("OutlineClose")
    vim.cmd("ccl")
    vim.cmd("lcl")

    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("term:") ~= nil then
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})
