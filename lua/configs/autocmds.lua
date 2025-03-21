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

-- Close lazy buffer q
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "toggleterm", "qf" },
  group = vim.api.nvim_create_augroup("user_add_buf_quit_hotkey", { clear = true }),
  command = "nnoremap <buffer><silent> q <CMD>close!<CR>",
})

vim.api.nvim_create_autocmd({ "QuitPre" }, {
  callback = function()
    local current_win = vim.api.nvim_get_current_win()
    local wins = vim.api.nvim_list_wins()

    local editable_count = 0
    for _, w in ipairs(wins) do
      local current_buf = vim.api.nvim_win_get_buf(w)
      ---@diagnostic disable-next-line: deprecated
      if vim.api.nvim_buf_get_option(current_buf, "buftype") == "" then
        editable_count = editable_count + 1
      end
    end

    if editable_count <= 1 then
      local current_buf = vim.api.nvim_win_get_buf(current_win)
      ---@diagnostic disable-next-line: deprecated
      if vim.api.nvim_buf_get_option(current_buf, "buftype") == "" then
        vim.cmd("qall!")
      end
    end

    -- Leave nvim restore cursor style
    vim.api.nvim_create_autocmd("VimLeave", {
      group = vim.api.nvim_create_augroup("user_quit_restore_cursor_style", { clear = true }),
      pattern = "*",
      command = 'set guicursor= | call chansend(v:stderr, "\x1b[ q")',
    })
  end,
})

-- Fixed qf repl win position and  height
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "dap-repl", "qf" },
--   group = vim.api.nvim_create_augroup("user_set_qf_repl_window", { clear = true }),
--   -- command = "wincmd K|setlocal winfixheight|setlocal nonumber",
--   command = "setlocal winfixheight|setlocal nonumber",
-- })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf" },
  group = vim.api.nvim_create_augroup("user_resize_window_position", { clear = true }),
  callback = function()
    local current_win = vim.api.nvim_get_current_win()
    vim.defer_fn(function()
      vim.wo[current_win].winbar = ""
    end, 0)

    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local current_buf = vim.api.nvim_win_get_buf(w)
      ---@diagnostic disable-next-line: deprecated
      if vim.api.nvim_buf_get_option(current_buf, "filetype") == "neo-tree" then
        vim.defer_fn(function()
          vim.cmd("Neotree toggle")
          vim.cmd("Neotree toggle")
          vim.cmd("wincmd p")
        end, 100)
      end
    end
  end,
})
