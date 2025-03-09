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

vim.api.nvim_create_autocmd("QuitPre", {
  group = vim.api.nvim_create_augroup("user_quit_before_close_windows", { clear = true }),
  callback = function()
    local dap_ok, dap = pcall(require, "dap")
    if dap_ok then
      dap.repl.close()
    end

    local dapui_ok, dapui = pcall(require, "dapui")
    if dapui_ok then
      dapui.close()
    end

    vim.cmd.cclose()
    vim.cmd.lclose()

    local tree_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()

    local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(0), "filetype")
    local fts_not_close = {
      "NvimTree",
      "Outline",
      "TelescopePrompt",
      "alpha",
      "help",
      "lazy",
      "mason",
      "qf",
    }

    if vim.tbl_contains(fts_not_close, ft) then
      return
    end

    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if
        bufname:match("NvimTree_") ~= nil
        or bufname:match("OUTLINE_") ~= nil
        or bufname:match("Trouble") ~= nil
      then
        table.insert(tree_wins, w)
      end

      local lft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(w), "filetype")
      if lft == "help" then
        table.insert(tree_wins, w)
      end

      if vim.api.nvim_win_get_config(w).relative ~= "" then
        table.insert(floating_wins, w)
      end
    end

    if 1 == #wins - #floating_wins - #tree_wins then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(tree_wins) do
        vim.api.nvim_win_close(w, true)
      end
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
  pattern = { "lazy", "NvimTree" },
  group = vim.api.nvim_create_augroup("user_add_buf_quit_hotkey", { clear = true }),
  command = "nnoremap <buffer><silent> <Esc> <CMD>close!<CR>",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lazy" },
  group = vim.api.nvim_create_augroup("user_add_buf_quit_hotkey", { clear = true }),
  command = "nnoremap <buffer><silent> <Esc> <CMD>close!<CR>",
})
