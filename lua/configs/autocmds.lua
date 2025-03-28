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

-- Set formatoptions
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("user_set_formatoptions", { clear = true }),
  command = "setlocal formatoptions-=o",
})

-- Close buffer with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "toggleterm", "qf" },
  group = vim.api.nvim_create_augroup("user_add_buf_quit_hotkey_q", { clear = true }),
  command = "nnoremap <buffer><silent> q <CMD>close!<CR>",
})

-- Close buffer with esc
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lazy" },
  group = vim.api.nvim_create_augroup("user_add_buf_quit_hotkey_esc", { clear = true }),
  command = "nnoremap <buffer><silent> <ESC> <CMD>close!<CR>",
})

vim.api.nvim_create_autocmd({ "QuitPre" }, {
  group = vim.api.nvim_create_augroup("user_quit_window_make_sure_other_closed", { clear = true }),
  callback = function()
    local current_win = vim.api.nvim_get_current_win()
    local wins = vim.api.nvim_list_wins()

    local editable_count = 0
    for _, w in ipairs(wins) do
      local b = vim.api.nvim_win_get_buf(w)
      if vim.bo[b].buftype == "" then
        editable_count = editable_count + 1
      end
    end

    if editable_count <= 1 then
      local b = vim.api.nvim_win_get_buf(current_win)
      if vim.bo[b].buftype == "" then
        vim.cmd("confirm qall")
      end
    end
  end,
})

-- Fixed qf repl win position and  height
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "dap-repl", "qf" },
--   group = vim.api.nvim_create_augroup("user_set_qf_repl_window", { clear = true }),
--   -- command = "wincmd K|setlocal winfixheight|setlocal nonumber",
--   command = "setlocal winfixheight|setlocal nonumber",
-- })
