local function lspSymbol(name, icon)
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

local icons = require("configs.icons")
lspSymbol("Error", icons.diagnostics.Error)
lspSymbol("Info", icons.diagnostics.Info)
lspSymbol("Hint", icons.diagnostics.Hint)
lspSymbol("Warn", icons.diagnostics.Warn)

vim.diagnostic.config({
  virtual_text = {
    prefix = "",
  },
  signs = true,
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
