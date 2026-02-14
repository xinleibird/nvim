local M = {
  "saghen/blink.cmp",
  -- use a release tag to download pre-built binaries
  -- version = "1.3.1", -- fallback 1.3.1 to fix markdown lost buffer provier --- https://github.com/Saghen/blink.cmp/issues/1943
  -- use a release tag to download pre-built binaries
  version = "1.*",
  -- or build it yourself
  -- build = "cargo build --release",
  dependencies = {
    "olimorris/codecompanion.nvim",
    "neovim/nvim-lspconfig",
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "snacks.nvim", words = { "Snacks" } },
        },
      },
    },
    {
      "kola-web/blink-alias-path",
    },
    {
      "brenoprata10/nvim-highlight-colors",
      config = function()
        require("nvim-highlight-colors").setup({})
      end,
    },
  },
  init = function()
    if vim.fn.has("nvim-0.11") == 1 and vim.lsp.config then
      local capabilities = {
        textDocument = {
          foldingrange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      }
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

      vim.lsp.config("*", {
        capabilities = capabilities,
      })
    end
  end,
  opts = {
    keymap = {
      preset = "default",
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_forward()
          else
            return cmp.select_and_accept()
          end
        end,
        "fallback",
      },
      ["<CR>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "fallback",
      },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        lua = { "lazydev", "lsp", "path", "snippets", "buffer" },
        html = { "lsp", "alias_path", "snippets", "buffer" },
        css = { "lsp", "alias_path", "snippets", "buffer" },
        javascriptreact = { "lsp", "alias_path", "snippets", "buffer" },
        typescriptreact = { "lsp", "alias_path", "snippets", "buffer" },
        ["dap-repl"] = { "lsp" },
      },
      -- min_keyword_length = function()
      --   return vim.bo.filetype == "markdown" and 2 or 0
      -- end,
      min_keyword_length = 0,
      providers = {
        alias_path = {
          name = "aliasPath",
          module = "blink-alias-path",
          opts = {
            ignore_root_slash = false,
            path_mappings = {
              ["/"] = "${folder}/public/",
            },
          },
        },
        lsp = {
          fallbacks = {},
          transform_items = function(_, items)
            local filetype = vim.bo.filetype
            local should_emmet_show = true
            if filetype == "javascriptreact" or filetype == "typescriptreact" then
              should_emmet_show = (function()
                local node = vim.treesitter.get_node()
                while node do
                  local type = node:type()
                  if type == "jsx_element" or type == "jsx_self_closing_element" or type == "jsx_fragment" then
                    return true
                  end
                  if type == "jsx_expression" then
                    return false
                  end
                  node = node:parent()
                end
                return false
              end)()
            end

            return vim.tbl_filter(function(item)
              if item.client_name == "emmet_language_server" then
                item.kind_icon = "󰯙"
                return should_emmet_show
              end

              if item.client_name == "typescript-tools" then
                if item.kind == 9 then
                  item.kind_icon = ""
                end
              end

              if item.client_name == "html" then
                -- disable emmet_language_server tag's auto close "</div> etc."
                return item.textEdit.newText:find("^%$%d+</%w+>$") == nil
              end

              return true
            end, items)
          end,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              item.kind_icon = "󱙷"
            end
            return items
          end,
        },
        cmdline = {
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              item.kind_icon = ""
            end
            return items
          end,
        },
        snippets = {
          --- @param ctx blink.cmp.Context
          should_show_items = function(ctx)
            local keyword = ctx.get_keyword()
            -- hide snippets after trigger character
            local not_trigger_characters = ctx.trigger.initial_kind ~= "trigger_character" and keyword ~= ""

            local success, node = pcall(vim.treesitter.get_node)
            local enable_snippets = true
            if
              success
              and node
              and vim.tbl_contains(
                { "comment", "line_comment", "block_comment", "string_literal", "string" },
                node:type()
              )
            then
              enable_snippets = false
            end

            return not_trigger_characters and enable_snippets
          end,
          opts = {
            friendly_snippets = false,
            search_paths = { vim.fn.stdpath("config") .. "/snippets" },
            global_snippets = {},
          },
        },
        buffer = {
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              -- disable completion for Chinese characters
              return string.find(item.insertText, "[\xE4-\xE9][\x80-\xBF][\x80-\xBF]") == nil
              -- disable completion for non-ascii characters
              -- return string.find(item.insertText, "[^a-zA-Z0-9%s%p]") == nil
            end, items)
          end,
          opts = {
            -- filter to only "normal" buffers
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
                return vim.bo[bufnr].buftype == "" or ft == "codecompanion"
              end, vim.api.nvim_list_bufs())
            end,
          },
        },
      },
    },
    completion = {
      list = {
        selection = {
          auto_insert = false,
        },
      },
      menu = {
        -- border = "solid",
        draw = {
          padding = { 1, 1 },

          -- completion menu style
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },

          -- show completion kind
          components = {
            -- customize the drawing of kind icons
            kind_icon = {
              text = function(ctx)
                -- default kind icon
                local icon = ctx.kind_icon
                -- if LSP source, check for color derived from documentation
                if ctx.item.source_name == "LSP" then
                  local color_item =
                    require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr ~= "" then
                    icon = color_item.abbr
                  end
                end
                return icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                -- default highlight group
                local highlight = "BlinkCmpKind" .. ctx.kind
                -- if LSP source, check for color derived from documentation
                if ctx.item.source_name == "LSP" then
                  local color_item =
                    require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr_hl_group then
                    highlight = color_item.abbr_hl_group
                  end
                end
                return highlight
              end,
            },
          },
        },
      },
      documentation = {
        window = {
          -- border = "solid",
        },
      },
    },
    signature = {
      enabled = true,
      window = {
        border = "solid",
        show_documentation = false,
      },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      -- prebuilt_binaries = { force_version = "v1.0.0" },
      sorts = {
        -- lua sorter slowly
        -- function(a, b)
        --   if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
        --     return
        --   end
        --   return a.client_name == "emmet_language_server"
        -- end,
        "exact",
        -- defaults
        "score",
        "sort_text",
      },
    },
    cmdline = {
      enabled = false,
      sources = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" or type == "@" then
          return { "cmdline" }
        end
        return {}
      end,
      keymap = {
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
              return cmp.accept()
            end
          end,
          "show_and_insert",
          -- "select_next",
          -- "fallback",
        },
        ["<CR>"] = { "select_accept_and_enter", "fallback" },
        -- ["<CR>"] = { "select_and_accept", "fallback" },
      },
      -- completion = { menu = { auto_show = true } },
    },
  },
  opts_extend = { "sources.default" },
}

return M
