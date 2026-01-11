local icons = require("configs.icons")
vim.diagnostic.config({
  virtual_text = {
    prefix = function(diagnostic)
      if diagnostic.severity == vim.diagnostic.severity.HINT then
        return icons.diagnostics.Hint
      end
      if diagnostic.severity == vim.diagnostic.severity.INFO then
        return icons.diagnostics.Info
      end
      if diagnostic.severity == vim.diagnostic.severity.WARN then
        return icons.diagnostics.Warn
      end
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        return icons.diagnostics.Error
      end

      return ""
    end,
    source = true,
  },
  float = {
    source = true,
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
  "eslint",
  "emmet_language_server",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "rust_analyzer",
  "svelte",
  "tailwindcss",
  -- "ts_ls",
  "vimls",
  "vtsls",
  "volar",
  "yamlls",
})
