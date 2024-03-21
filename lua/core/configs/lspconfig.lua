local icons = require("core.configs.icons")
local function lspSymbol(name, icon)
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

lspSymbol("Error", icons.diagnostics.Error)
lspSymbol("Info", icons.diagnostics.Info)
lspSymbol("Hint", icons.diagnostics.Hint)
lspSymbol("Warn", icons.diagnostics.Warning)

vim.diagnostic.config({
  virtual_text = {
    prefix = "",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- export on_attach & capabilities
-- local on_attach = function(client, bufnr) end
local on_attach = function(_, _) end

-- disable semanticTokens
local on_init = function(client, _)
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local config = function()
  local servers = {
    "bashls",
    "clangd",
    "cssls",
    "gopls",
    "html",
    "vimls",
  }

  local lspconfig = require("lspconfig")
  local util = require("lspconfig.util")

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
      on_init = on_init,
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end

  lspconfig.denols.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = util.root_pattern("deno.json", "deno.jsonc"),
  })

  lspconfig.eslint.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      rulesCustomizations = {
        { rule = "*", severity = "info" },
      },
    },
  })

  lspconfig.tsserver.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = util.root_pattern("tsconfig.json", "jsconfig.json"),
    settings = {
      -- diagnostics = { ignoredCodes = { 6133 } },
    },
  })

  local ss_ok, schemastore = pcall(require, "schemastore")
  local ss_json_settings = {}
  local ss_yaml_settings = {}
  if ss_ok then
    ss_json_settings = {
      json = {
        schemas = schemastore.json.schemas(),
        validate = { enable = true },
      },
    }
    ss_yaml_settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    }
  end

  lspconfig.jsonls.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    settings = ss_json_settings,
  })

  lspconfig.yamlls.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    settings = ss_yaml_settings,
  })

  local neodev_ok, neodev = pcall(require, "neodev")
  if neodev_ok then
    neodev.setup()
  end

  lspconfig.lua_ls.setup({
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        telemetry = { enable = false },
        runtime = {
          version = "LuaJIT",
          -- path = { "?.lua", "?/init.lua" },
          -- pathStrict = true,
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.fn.expand("$VIMRUNTIME/lua"),
            vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
          },

          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  })
end

local M = {
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  config = config,
}

return M
