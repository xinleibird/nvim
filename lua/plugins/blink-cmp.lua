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
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
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
        "snippet_forward",
        "fallback",
      },
    },
    signature = { enabled = true },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    cmdline = {
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
        ["<CR>"] = { "accept_and_enter", "fallback" },
      },
      -- completion = { menu = { auto_show = true } },
    },
    sources = {
      min_keyword_length = function()
        return vim.bo.filetype == "markdown" and 2 or 0
      end,
      -- default = { "lazydev", "path", "snippets", "buffer", "lsp" },
      default = function()
        local success, node = pcall(vim.treesitter.get_node)
        if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
          return { "buffer" }
        elseif vim.bo.filetype == "lua" then
          return { "lazydev", "lsp", "path", "snippets", "buffer" }
        else
          return { "lsp", "path", "snippets", "buffer" }
        end
      end,
      providers = {
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
            return ctx.trigger.initial_kind ~= "trigger_character"
          end,
        },
        buffer = {
          transform_items = function(_, items) -- filter include Chinese characters item
            return vim.tbl_filter(function(item)
              -- return string.find(item.insertText, "[\xE4-\xE9][\x80-\xBF][\x80-\xBF]") == nil
              return string.find(item.insertText, "[^a-zA-Z0-9%s%p]") == nil
            end, items)
          end,
        },
        lsp = {},
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
    completion = {
      menu = {
        draw = {
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}

return M
