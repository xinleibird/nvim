local M = {
  linters_by_ft = {

    -- markdown = {'vale',}
    javascript = { "eslint_d" },
    -- javascriptreact = { "eslint" },
    -- typescript = { "eslint" },
    -- typescriptreact = { "eslint" },

    bash = { "shellcheck" },
    zsh = { "shellcheck" },
  },
}

local function init()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("nvim-lint-group", { clear = true }),
    pattern = "*",
    callback = function()
      require("lint").try_lint()
    end,
  })

  return M
end

return init()
