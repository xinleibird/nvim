local M = {
  "mfussenegger/nvim-lint",
  event = "BufEnter",
  init = function()
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "CursorHold", "CursorHoldI" }, {
      group = vim.api.nvim_create_augroup("nvim-lint-group", { clear = true }),
      pattern = "*",
      callback = function()
        if not vim.b.disable_autolint then -- for bigfile disable autolint
          require("lint").try_lint()
        end
      end,
    })
  end,
  config = function()
    require("lint").linters_by_ft = {
      bash = { "shellcheck" },
      html = { "htmlhint" },
      sh = { "shellcheck" },
      zsh = { "shellcheck" },
    }
  end,
}

return M
