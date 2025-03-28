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

-- Close buffer with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf" },
  group = vim.api.nvim_create_augroup("user_buf_quit_hotkey_q", { clear = true }),
  command = "nnoremap <buffer><silent> q <cmd>close!<CR>",
})

-- Close buffer with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "checkhealth" },
  group = vim.api.nvim_create_augroup("user_buf_delete_hotkey_q", { clear = true }),
  command = "nnoremap <buffer><silent> q <cmd>bd<CR>|nnoremap <buffer><silent> <C-w>q <cmd>bd<CR>",
})

-- Close buffer with esc
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lazy" },
  group = vim.api.nvim_create_augroup("user_buf_quit_hotkey_esc", { clear = true }),
  command = "nnoremap <buffer><silent> <ESC> <cmd>close!<CR>",
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
