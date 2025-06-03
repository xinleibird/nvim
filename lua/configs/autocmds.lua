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

local hotkey_group = vim.api.nvim_create_augroup("user_buf_quit_hotkey", { clear = true })
-- Close window with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "help" },
  group = hotkey_group,
  command = "nnoremap <buffer><silent> q <cmd>close!<CR>",
})
-- Close window with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "dapui_scopes",
    "dap-repl",
    "dapui_console",
    "dapui_watches",
    "dapui_stacks",
    "dapui_breakpoints",
  },
  group = hotkey_group,
  command = "nnoremap <buffer><silent> q <cmd>lua require('dapui').close()<CR>",
})
-- Close checkhealth buffer with q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "checkhealth" },
  group = hotkey_group,
  command = "nnoremap <buffer><silent> q <cmd>bd<CR>|nnoremap <buffer><silent> <C-w>q <cmd>bd<CR>",
})
-- Close checkhealth buffer with Esc
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lazy", "qf" },
  group = hotkey_group,
  command = "nnoremap <buffer><silent> <Esc> <cmd>close!<CR>",
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufNewFile" }, {
  pattern = "*",
  group = vim.api.nvim_create_augroup("user_formatoptions_minus_o", { clear = true }),
  command = "setlocal formatoptions-=o",
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

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "dap-repl" then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
      if vim.bo[b].buftype == "" then
        vim.cmd("confirm qall")
        -- vim.cmd("qall!")
      end
    end
  end,
})
