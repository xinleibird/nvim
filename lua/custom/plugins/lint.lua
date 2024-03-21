local M = {
  "mfussenegger/nvim-lint",
  -- event = "BufWritePre",
  lazy = false,
  config = function()
    require("lint").linters_by_ft = {
      -- markdown = {'vale',}
      -- javascript = { "eslint" },
      -- javascriptreact = { "eslint" },
      -- typescript = { "eslint" },
      -- typescriptreact = { "eslint" },

      bash = { "shellcheck" },
      zsh = { "shellcheck" },
    }

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim-lint-group", { clear = true }),
      pattern = "*",
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
return M
