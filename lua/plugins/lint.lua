local M = {
  "mfussenegger/nvim-lint",
  event = "BufEnter",
  init = function()
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "CursorHold", "CursorHoldI" }, {
      group = vim.api.nvim_create_augroup("nvim-lint-group", { clear = true }),
      pattern = "*",
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
  config = function()
    require("lint").linters_by_ft = {
      bash = { "shellcheck" },
      html = { "htmlhint" },
      zsh = { "shellcheck" },
    }
  end,
}

return M
