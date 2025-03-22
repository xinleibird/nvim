local M = {
  "saghen/blink.cmp",
  -- use a release tag to download pre-built binaries
  version = "*",
  -- or build it yourself
  -- build = "cargo build --release",
  event = "VimEnter",
  dependencies = {
    {
      "olimorris/codecompanion.nvim",
      config = function()
        require("codecompanion").setup({
          opts = {
            -- show_defaults = false,
            log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
            language = "Chinese",
          },
          strategies = {
            chat = {
              adapter = "gemini",
            },
            inline = {
              adapter = "gemini",
            },
          },
          adapters = {},
          display = {
            action_palette = {
              width = 95,
              height = 10,
              prompt = "Prompt ", -- Prompt used for interactive LLM calls
              provider = "default", -- default|telescope|mini_pick
              opts = {
                show_default_actions = true, -- Show the default actions in the action palette?
                show_default_prompt_library = true, -- Show the default prompt library in the action palette?
              },
            },
          },
        })
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
      -- default = { "lazydev", "path", "snippets", "buffer", "lsp" },
      default = function()
        local success, node = pcall(vim.treesitter.get_node)
        if
          success
          and node
          and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
        then
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
        codecompanion = {
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              item.kind_icon = ""
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
              return string.find(item.insertText, "[\xE4-\xE9][\x80-\xBF][\x80-\xBF]") == nil
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
