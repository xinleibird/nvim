local M = {
  "neovim/nvim-lspconfig",
  event = "BufRead",
  dependencies = {
    "folke/neodev.nvim",
    "b0o/schemastore.nvim",
  },

  init = function()
    local icons = require("configs.icons")
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
  end,

  config = function()
    local on_attach = function() end

    local on_init = function(client)
      -- semanticTokens 'vim.g.semantic_tokens'
      if not vim.g["semantic_tokens"] then
        if client.supports_method("textDocument/semanticTokens") then
          client.server_capabilities.semanticTokensProvider = nil
        end
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

    local servers = {
      -- "bashls",
      "clangd",
      "cssls",
      "emmet_language_server",
      "gopls",
      "html",
      -- "tsserver",
      "rust_analyzer",
      "vimls",
      "vtsls",
    }

    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")

    -- for _, lsp in ipairs(servers) do
    --   lspconfig[lsp].setup({
    --     on_init = on_init,
    --     on_attach = on_attach,
    --     capabilities = capabilities,
    --   })
    -- end

    lspconfig.bashls.setup({
      on_init = on_init,
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "sh", "zsh" },
    })

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
          -- { rule = "no-unused-vars", severity = "info" },
          -- { rule = "*", severity = "info" },
        },
      },
    })

    lspconfig.rust_analyzer.setup({
      on_attach = function(client, bufnr)
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = true,
          check = { command = "clippy", features = "all" },
          imports = {
            granularity = {
              group = "module",
            },
            prefix = "self",
          },
          cargo = {
            allFeatures = true,
            buildScripts = {
              enable = true,
            },
          },
          procMacro = {
            enable = true,
          },
          -- assist = {
          --   importGranularity = "module",
          --   importPrefix = "self",
          -- },
          -- diagnostics = {
          --   enable = true,
          --   enableExperimental = true,
          -- },
          -- cargo = {
          --   loadOutDirsFromCheck = true,
          --   features = "all", -- avoid error: file not included in crate hierarchy
          -- },
          -- procMacro = {
          --   enable = true,
          -- },
          -- inlayHints = {
          --   chainingHints = true,
          --   parameterHints = true,
          --   typeHints = true,
          -- },
        },
        -- ["rust-analyzer.server.extraEnv"] = { ["RUSTUP_TOOLCHAIN"] = "stable" },
      },
      -- on_init = on_init,
      -- on_attach = on_attach,
      -- capabilities = capabilities,
    })

    -- lspconfig.tsserver.setup({
    --   on_init = on_init,
    --   on_attach = on_attach,
    --   capabilities = capabilities,
    --   -- settings = {
    --   --   diagnostics = { ignoredCodes = { 6133 } },
    --   -- },
    -- })

    -- lspconfig.vtsls.setup({
    --   on_init = on_init,
    --   on_attach = on_attach,
    --   capabilities = capabilities,
    --   -- settings = {
    --   --   diagnostics = { ignoredCodes = { 6133 } },
    --   -- },
    -- })

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
          runtime = {
            version = "LuaJIT",
            -- path = { "?.lua", "?/init.lua" },
            -- pathStrict = true,
          },
          diagnostics = {
            globals = { "use", "vim" },
          },
          hint = {
            enable = true,
            setType = true,
          },
          telemetry = { enable = false },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
              [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
            },

            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    })
  end,
}

return M
