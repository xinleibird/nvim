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
      ["<Enter>"] = {
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
        if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then -- in comment just accept buffer
          return { "buffer" }
        elseif vim.bo.filetype == "lua" then -- enable lazydev for lua
          return { "lazydev", "lsp", "path", "snippets", "buffer" }
        elseif vim.bo.filetype == "html" then -- disable emmet_language_server snippets
          return { "lsp", "path", "buffer" }
        else
          return { "lsp", "path", "snippets", "buffer" }
        end
      end,
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
        draw = {
          padding = { 1, 2 },
          -- show completion kind
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
        },
      },
      documentation = {},
    },
    signature = {
      enabled = true,
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
        ["<CR>"] = { "accept_and_enter", "fallback" },
      },
      -- completion = { menu = { auto_show = true } },
    },
  },
  opts_extend = { "sources.default" },
}

return M
