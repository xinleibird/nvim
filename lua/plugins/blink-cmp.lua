local M = {
  "saghen/blink.cmp",
  -- use a release tag to download pre-built binaries
  version = "*",
  -- or build it yourself
  -- build = "cargo build --release",
  event = "VimEnter",
  dependencies = {
    "onsails/lspkind.nvim",
    { "saghen/blink.compat", version = "*", lazy = true, opts = {} },
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
    cmdline = {
      keymap = {
        ["<Tab>"] = { "accept" },
        ["<CR>"] = { "accept_and_enter", "fallback" },
      },
      -- (optionally) automatically show the menu
      completion = { menu = { auto_show = true } },
    },
    sources = {
      default = { "lazydev", "path", "snippets", "buffer", "lsp" },
      providers = {
        lazydev = {
          -- name = "lazydev",
          -- module = "blink.compat.source",

          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        cmdline = {
          min_keyword_length = function(ctx)
            -- when typing a command, only show when the keyword is 3 characters or longer
            if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
              return 2
            end
            return 0
          end,
        },
        snippets = {
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= "trigger_character"
          end,
        },
        lsp = {
          should_show_items = function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
            local after_cursor = vim.api.nvim_get_current_line():sub(col)
            -- NOTE: Disable tag completion for emmet
            return before_cursor:match(">$") == nil and after_cursor:match("^<") == nil
          end,
          -- transform_items = function(ctx, items)
          --   for _, item in ipairs(items) do
          --     item.kind_icon = ""
          --     item.kind_name = "LSP"
          --   end
          --   return items
          -- end,
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
    completion = {
      menu = {
        draw = {
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                else
                  icon = require("lspkind").symbolic(ctx.kind, {
                    mode = "symbol",
                  })
                end

                return icon .. ctx.icon_gap
              end,

              -- Optionally, use the highlight groups from nvim-web-devicons
              -- You can also add the same function for `kind.highlight` if you want to
              -- keep the highlight groups in sync with the icons.
              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },
          },
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}

return M
