local M = {
  "saghen/blink.cmp",
  -- use a release tag to download pre-built binaries
  version = "1.3.1", -- fallback 1.3.1 to fix markdown lost buffer provier --- https://github.com/Saghen/blink.cmp/issues/1943
  -- or build it yourself
  -- build = "cargo build --release",
  dependencies = {
    "olimorris/codecompanion.nvim",
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          "lazy.nvim",
          "nvim-dap-ui",
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "snacks.nvim", words = { "Snacks", "snacks" } },
        },
      },
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
      -- default = { "lsp", "path", "snippets", "buffer" },
      default = function()
        local success, node = pcall(vim.treesitter.get_node)
        if
          success
          and node
          and vim.tbl_contains({ "comment", "line_comment", "block_comment", "string_literal", "string" }, node:type())
        then
          return { "path", "buffer" }
        elseif vim.bo.filetype == "lua" then
          return { "lazydev", "lsp", "path", "snippets", "buffer" }
        elseif vim.bo.filetype == "dap-repl" then
          return { "lsp" }
        else
          return { "lsp", "path", "snippets", "buffer" }
        end
      end,
      -- min_keyword_length = function()
      --   return vim.bo.filetype == "markdown" and 2 or 0
      -- end,
      min_keyword_length = 0,
      providers = {
        lsp = {
          override = {
            -- trigger character add {} [] ()
            get_trigger_characters = function(self)
              local ignored = { "}", "]", ")", "" }
              local trigger_characters = self:get_trigger_characters()
              trigger_characters = vim.tbl_filter(function(trigger)
                -- disable {, [, ( trigger
                return not vim.tbl_contains(ignored, trigger)
              end, trigger_characters)
              return trigger_characters
            end,
          },
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        cmdline = {
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              item.kind_icon = ""
            end
            return items
          end,
        },
        codecompanion = {
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              item.kind_icon = "󰊠"
            end
            return items
          end,
        },
        snippets = {
          --- @param ctx blink.cmp.Context
          should_show_items = function(ctx)
            local keyword = ctx.get_keyword()
            -- hide snippets after trigger character
            return ctx.trigger.initial_kind ~= "trigger_character" and keyword ~= ""
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
        -- (optionally) always prioritize exact matches
        "exact",
        -- default sorts
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
