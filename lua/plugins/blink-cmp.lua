local M = {
  "saghen/blink.cmp",
  build = "cargo build --release",
  dependencies = {
    {
      "hrsh7th/nvim-cmp",
      config = function()
        require("cmp").setup({})
      end,
    },
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
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = false,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },
    sources = {
      providers = {
        snippets = {
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= "trigger_character"
          end,
        },
        lsp = {
          -- should_show_items = function()
          --   local col = vim.api.nvim_win_get_cursor(0)[2]
          --   local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
          --   local after_cursor = vim.api.nvim_get_current_line():sub(col)
          --   -- NOTE: Disable tag completion for emmet
          --   return before_cursor:match(">$") == nil and after_cursor:match("^<") == nil
          -- end,
          transform_items = function(_, items)
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
