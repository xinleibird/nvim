local icons = require("configs.icons")
vim.diagnostic.config({
  virtual_text = {
    prefix = "",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
    },
  },
  underline = true,
  update_in_insert = false,
})

vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
  root_markers = { ".git" },
})

vim.lsp.enable({
  "bashls",
  "cssls",
  "emmet_language_server",
  "eslint",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "rust_analyzer",
  -- "ts_ls",
  "vimls",
  "vtsls",
  "yamlls",
})
