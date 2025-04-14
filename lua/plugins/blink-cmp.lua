local M = {
  "saghen/blink.cmp",
  -- use a release tag to download pre-built binaries
  -- version = "*",
  -- or build it yourself
  build = "cargo build --release",
  dependencies = {
    "olimorris/codecompanion.nvim",
    "folke/lazydev.nvim",
    "rafamadriz/friendly-snippets",
  },
  event = "VimEnter",
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
        lua = { "lazydev", "lsp", "path", "snippets", "buffer" }, -- enable lazydev for lua
        html = { "lsp", "path", "buffer" }, -- disable emmet_language_server snippets
      },
      min_keyword_length = function()
        return vim.bo.filetype == "markdown" and 2 or 0
      end,
      providers = {
        lsp = {
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              if item.client_name == "html" then
                -- disable emmet_language_server tag's auto close "</div> etc."
                return item.textEdit.newText:find("^%$%d+</%w+>$") == nil
              end
              return true
            end, items)
          end,
          override = {
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
        path = {
          opts = {
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              item.kind_icon = "󰢚"
              item.kind_name = "LazyDev"
            end
            return items
          end,
        },
        cmdline = {
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              item.kind_icon = ""
              item.kind_name = "CmdLine"
            end
            return items
          end,
        },
        codecompanion = {
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              item.kind_icon = "󰊠"
              item.kind_name = "Companion"
            end
            return items
          end,
        },
        snippets = {
          should_show_items = function(ctx)
            local keyword = ctx.get_keyword()
            return ctx.trigger.initial_kind ~= "trigger_character" and keyword ~= ""
          end,
          opts = {
            friendly_snippets = true,
            search_paths = { vim.fn.stdpath("config") .. "/snippets" },
            global_snippets = {},
            extended_filetypes = {},
            ignored_filetypes = {},
          },
        },
        buffer = {
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              -- disable completion for Chinese characters
              -- return string.find(item.insertText, "[\xE4-\xE9][\x80-\xBF][\x80-\xBF]") == nil

              -- disable completion for non-ascii characters
              return string.find(item.insertText, "[^a-zA-Z0-9%s%p]") == nil
            end, items)
          end,
          should_show_items = function(ctx)
            local keyword = ctx.get_keyword()
            return keyword ~= ""
          end,
        },
      },
    },
    completion = {
      menu = {
        -- border = "solid",
        draw = {
          padding = { 1, 1 },
          -- show completion kind
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
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
        -- border = "solid",
        show_documentation = true,
      },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = {
        -- (optionally) always prioritize exact matches
        -- "exact",
        function(a, b)
          if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
            return
          end
          return a.client_name == "html" and b.client_name == "emmet_language_server"
        end,
        -- default sorts
        "score",
        "sort_text",
      },
    },
    cmdline = {
      -- enabled = false,
      sources = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" or type == "@" then
          return { "path", "cmdline" }
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
          "select_next",
        },
        ["<CR>"] = { "select_accept_and_enter", "fallback" },
      },
      -- completion = { menu = { auto_show = true } },
    },
  },
  opts_extend = { "sources.default" },
}

return M
