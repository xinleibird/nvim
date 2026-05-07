---@module "lazy"
---@type LazySpec
local M = {
  "saghen/blink.cmp",
  -- use a release tag to download pre-built binaries
  version = "*",
  -- or build it yourself
  -- build = "cargo build --release",
  dependencies = {
    "mayromr/blink-cmp-dap",
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          vim.env.VIMRUNTIME,
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
  ---@type blink.cmp.Config
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
      ["<C-y>"] = {
        function(cmp)
          cmp.show({ providers = { "emmet" } })
        end,
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
        ["dap-repl"] = { "dap", "lsp" },
      },
      -- min_keyword_length = function()
      --   return vim.bo.filetype == "markdown" and 2 or 0
      -- end,
      min_keyword_length = 0,
      providers = {
        dap = {
          name = "dap",
          module = "blink-cmp-dap",
        },
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
        path = {
          opts = {
            -- TIP: Show hidden files by pressing <C-e> to close completion, then press "."
            show_hidden_files_by_default = false,
          },
        },
        emmet = {
          name = "emmet",
          module = "blink.cmp.sources.lsp",
          enabled = function()
            return vim.tbl_contains({
              "astro",
              "css",
              "eruby",
              "html",
              "htmlangular",
              "htmldjango",
              "javascriptreact",
              "less",
              "sass",
              "scss",
              "svelte",
              "typescriptreact",
              "vue",
            }, vim.bo.filetype)
          end,
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              if item.client_name == "emmet_language_server" then
                item.kind_icon = "󰯙"
                return true
              end

              return false
            end, items)
          end,
        },
        lsp = {
          fallbacks = {},
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              if item.client_name == "emmet_language_server" then
                return false
              end

              if item.client_name == "html" then
                -- disable emmet_language_server tag's auto close "</div> etc."
                return item.textEdit.newText:find("^%$%d+</%w+>$") == nil
              end

              return true
            end, items)
          end,
          override = {
            -- trigger character add {} [] ()
            get_trigger_characters = function(self)
              local ignored = { "}", "]", ")", "" }
              local trigger_characters = self:get_trigger_characters()
              trigger_characters = vim.tbl_filter(function(trigger)
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
          score_offset = -3,
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
        border = "rounded",
        draw = {
          padding = { 1, 1 },

          -- completion menu style
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" }, { "source_icon", gap = 1 } },
          -- show completion kind
          components = {
            source_icon = {
              -- width = "fill",
              text = function(ctx)
                local source_map = {
                  lsp = "󰍹",
                  snippets = "",
                  buffer = "󰧭",
                  path = "󰉖",
                  alias_path = "󰉖",
                  cmdline = "",
                  lazydev = "󱙷",
                  dap = "󰨰",
                  codecompanion = "",
                }
                return source_map[ctx.source_id] or ctx.source_id:sub(1, 1):upper()
              end,
              highlight = function(ctx)
                return "BlinkCmpKind" .. ctx.kind
              end,
            },
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
          border = "rounded",
        },
      },
    },
    signature = {
      enabled = true,
      trigger = {
        enabled = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_insert = true,
        show_on_insert_on_trigger_character = true,
      },
      window = {
        border = "rounded",
        show_documentation = false,
      },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = {
        -- "exact",
        -- defaults
        "score",
        "sort_text",
      },
    },
    cmdline = {
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        if type == ":" or type == "@" then
          return { "cmdline" }
        end
        return {}
      end,
      keymap = {
        ["<Tab>"] = { "show", "accept" },
        ["<CR>"] = { "accept_and_enter", "fallback" },
      },
      completion = {
        menu = {
          auto_show = false,
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}

return M
