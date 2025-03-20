local M = {
  "saghen/blink.cmp",
  -- use a release tag to download pre-built binaries
  version = "*",
  -- or build it yourself
  -- build = "cargo build --release",
  dependencies = {
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
  },
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
    sources = {
      default = { "lazydev", "path", "snippets", "buffer", "lsp" },
      providers = {
        lazydev = {
          name = "lazydev",
          module = "blink.compat.source",

          -- name = "LazyDev",
          -- module = "lazydev.integrations.blink",

          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
        snippets = {
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= "trigger_character"
          end,
        },
        lsp = {
          fallbacks = { "lazydev" },
          -- should_show_items = function()
          --   local col = vim.api.nvim_win_get_cursor(0)[2]
          --   local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
          --   local after_cursor = vim.api.nvim_get_current_line():sub(col)
          --   -- NOTE: Disable tag completion for emmet
          --   return before_cursor:match(">$") == nil and after_cursor:match("^<") == nil
          -- end,
          transform_items = function(_, items)
            -- NOTE: Filter html-ls completion
            return vim.tbl_filter(function(item)
              return item.client_name ~= "html"
            end, items)
          end,
        },
      },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = {
        function(a, b)
          if
            (a.client_name == nil or b.client_name == nil)
            or (a.client_name == "html" or b.client_name == "html")
            or (a.client_name == b.client_name)
          then
            return
          end
          return b.client_name == "emmet_language_server"
        end,
        -- default sorts
        "score",
        "sort_text",
      },
    },
  },
  opts_extend = { "sources.default" },
}

return M
