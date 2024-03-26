local M = {
  "olimorris/persisted.nvim",
  event = "FileReadPre",
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistedSavePre",
      group = vim.api.nvim_create_augroup("user_before_save_session_close_misc_win", { clear = true }),
      callback = function()
        vim.cmd("silent! OutlineClose")
        vim.cmd("silent! DapUIClose")
      end,
    })
    vim.keymap.set("n", "<leader>ss", "<cmd>SessionSelect<CR>", { desc = "Recent Sessions" })
  end,
}

return M
