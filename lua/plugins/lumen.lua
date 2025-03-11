local M = {
  "vimpostor/vim-lumen",
  lazy = false,
  config = function()
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("user_lumen_dark_group", { clear = true }),
      pattern = "LumenDark",
      desc = "Handle dark mode change",
      callback = function()
        vim.cmd("Lazy reload alpha-nvim")
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("user_lumen_light_group", { clear = true }),
      pattern = "LumenLight",
      desc = "Handle light mode change",
      callback = function()
        vim.cmd("Lazy reload alpha-nvim")
      end,
    })
  end,
}

return M
