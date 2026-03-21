-- Disable automatic comment insertion on new line (o/O)
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufNewFile" }, {
  pattern = "*",
  group = vim.api.nvim_create_augroup("user_formatoptions_minus_o", { clear = true }),
  command = "setlocal formatoptions-=o",
})

-- Automatically close auxiliary windows (e.g., DAP REPL) and prompt to quit Neovim
-- when the last editable buffer is closed.
vim.api.nvim_create_autocmd("QuitPre", {
  group = vim.api.nvim_create_augroup("user_quit_window_make_sure_other_closed", { clear = true }),
  callback = function()
    -- The autocmd for persistence doesn't work, manually save.
    -- cause used "QuitPre"
    local persistence_ok, persistence = pcall(require, "persistence")
    if persistence_ok then
      persistence.save()
    end

    -- clean up CodeCompanion's Qwen CLI ACP connection and child processes before closing
    local codecompanion_ok, codecompanion = pcall(require, "codecompanion")
    if codecompanion_ok then
      local chat = codecompanion.last_chat()
      if chat and chat.acp_connection and chat.acp_connection.adapter.formatted_name == "Qwen CLI" then
        pcall(function()
          local nvim_pid = vim.fn.getpid()
          local sub_pid = vim.fn.system('pgrep -f "node.*node.*node.*qwen --acp"')
          local ancestors = require("utils").get_ancestors(sub_pid)
          local is_descendant = vim.tbl_contains(ancestors, nvim_pid)

          if is_descendant then
            vim.fn.system(("kill -9 " .. sub_pid))
          end

          chat.acp_connection:disconnect()
        end)
      end
      codecompanion.close_last_chat()
    end

    -- make close
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
      end
    end
  end,
})
