local M = {
  "olimorris/persisted.nvim",
  -- event = "BufReadPre", -- Ensure the plugin loads only when a buffer has been loaded
  dependencies = "nvim-telescope/telescope.nvim",
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistedSavePre",
      group = vim.api.nvim_create_augroup("user_before_save_session_close_misc_win", { clear = true }),
      callback = function()
        vim.cmd("Neotree close")
        vim.cmd("OutlineClose")
      end,
    })
    vim.keymap.set("n", "<leader>ss", "<cmd>SessionSelect<CR>", { desc = "Recent Sessions" })
  end,
  opts = {
    -- Your config goes here ...
  },
  config = function()
    require("telescope").load_extension("persisted")
  end,
}

return M
