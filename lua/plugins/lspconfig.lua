local M = {
  "neovim/nvim-lspconfig",
  event = "BufRead",
  dependencies = {
    "b0o/schemastore.nvim",
    "saghen/blink.cmp",
    {
      "hrsh7th/nvim-cmp",
      opts = function(_, opts)
        opts.sources = opts.sources or {}
        table.insert(opts.sources, {
          name = "lazydev",
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        })
      end,
    },
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- Library paths can be absolute
          -- "~/projects/my-awesome-lib",
          -- Or relative, which means they will be resolved from the plugin dir.
          "lazy.nvim",
          -- It can also be a table with trigger words / mods
          -- Only load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          -- always load the LazyVim library
          "LazyVim",
          -- Only load the lazyvim library when the `LazyVim` global is found
          { path = "LazyVim", words = { "LazyVim" } },
          -- Load the wezterm types when the `wezterm` module is required
          -- Needs `justinsgithub/wezterm-types` to be installed
          -- { path = "wezterm-types", mods = { "wezterm" } },
          -- Load the xmake types when opening file named `xmake.lua`
          -- Needs `LelouchHe/xmake-luals-addon` to be installed
          -- { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
        },
        -- always enable unless `vim.g.lazydev_enabled = false`
        -- This is the default
        enabled = function()
          return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
        end,
        -- disable when a .luarc.json file is found
        -- enabled = function(root_dir)
        --   return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
        -- end,
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
