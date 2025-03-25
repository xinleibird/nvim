local M = {
  "neovim/nvim-lspconfig",
  event = "VimEnter",
  dependencies = {
    "b0o/schemastore.nvim",
    "saghen/blink.cmp",
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
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

  opts = function()
    return {
      servers = {
        bashls = {
          filetypes = { "sh", "zsh" },
        },
        cssls = {},
        emmet_language_server = {},
        eslint = {
          settings = {
            rulesCustomizations = {
              -- { rule = "no-unused-vars", severity = "info" },
              -- { rule = "*", severity = "info" },
            },
          },
        },
        html = {},
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        -- use lazydev configurations
        lua_ls = {},
        rust_analyzer = {
          on_attach = function(_, bufnr)
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = true,
              check = {
                command = "clippy",
                features = "all",
              },
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
            },

            -- ["rust-analyzer.server.extraEnv"] = { ["RUSTUP_TOOLCHAIN"] = "stable" },
          },
        },
        -- tsserver = {
        --   settings = {
        --     diagnostics = { ignoredCodes = { 6133 } },
        --   },
        -- },
        vimls = {},
        vtsls = {
          -- settings = {
          --   diagnostics = { ignoredCodes = { 6133 } },
          -- },
        },
        yamlls = {
          settings = {

            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
      },
    }
  end,

  config = function(_, opts)
    local lspconfig = require("lspconfig")

    for server, config in pairs(opts.servers) do
      config.on_attach = function() end
      config.on_init = function(client)
        -- semanticTokens 'vim.g.semantic_tokens'
        if not vim.g["semantic_tokens"] then
          if client.supports_method("textDocument/semanticTokens") then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end
      end

      -- passing config.capabilities to blink.cmp merges with the capabilities in your
      -- `opts[server].capabilities, if you've defined it
      config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      config.capabilities.textDocument.completion.completionItem = {
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

      lspconfig[server].setup(config)
    end
  end,
}

return M
