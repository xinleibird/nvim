local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- cmp sources plugins
    {
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    {
      "hrsh7th/cmp-nvim-lsp-signature-help",
      event = "BufRead",
    },
    {
      -- snippet plugin
      "L3MON4D3/LuaSnip",
      dependencies = {
        "hrsh7th/nvim-cmp",
        "saadparwaiz1/cmp_luasnip",
        -- "rafamadriz/friendly-snippets",
      },
      init = function()
        require("luasnip").config.set_config({
          history = true,
          updateevents = "TextChanged,TextChangedI",
        })

        -- vscode format
        require("luasnip.loaders.from_vscode").lazy_load({ exclude = vim.g.vscode_snippets_exclude or {} })

        local snippets_path = vim.fn.stdpath("config") .. "/snippets"
        require("luasnip.loaders.from_vscode").lazy_load({ paths = snippets_path })

        require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })

        -- snipmate format
        require("luasnip.loaders.from_snipmate").load()
        require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })

        -- lua format
        require("luasnip.loaders.from_lua").load()
        require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

        vim.api.nvim_create_autocmd("InsertLeave", {
          callback = function()
            if
              require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
              and not require("luasnip").session.jump_active
            then
              require("luasnip").unlink_current()
            end
          end,
        })
      end,
    },
  },
  config = function()
    local cmp = require("cmp")
    local icons = require("configs.icons")
    local lspkind_icons = icons.lspkind

    local function border(hl_name)
      return {
        { "╭", hl_name },
        { "─", hl_name },
        { "╮", hl_name },
        { "│", hl_name },
        { "╯", hl_name },
        { "─", hl_name },
        { "╰", hl_name },
        { "│", hl_name },
      }
    end
    require("cmp").setup({
      completion = {
        completeopt = "menu,menuone",
      },

      window = {
        completion = {
          side_padding = 0,
          winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
          scrollbar = false,
          -- col_offset = -3,
        },
        documentation = {
          border = border("CmpDocBorder"),
          winhighlight = "Normal:CmpDoc",
        },
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      formatting = {

        -- fields = { "kind", "abbr", "menu" },
        fields = { "kind", "abbr" },

        format = function(entry, item)
          local icon = lspkind_icons[item.kind] or ""

          icon = " " .. icon .. " "
          item.menu = "   (" .. item.kind .. ")"
          item.kind = icon

          if entry.source.name == "nvim_lsp_signature_help" then
            item.kind = " " .. icons.ui.Ghost .. " "
          end

          if entry.source.name == "nvim_lsp" then
            local debug_name = entry.source:get_debug_name()

            if debug_name == "nvim_lsp:emmet_language_server" then
              item.kind = " " .. icons.ui.Emmet .. " "
            end
          end

          return item
        end,
      },

      mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),

        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            vim.fn.feedkeys(
              vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
              ""
            )
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
          else
            fallback()
          end
        end, { "i", "s" }),
      },
      sources = {
        { name = "nvim_lsp_signature_help", priority = 1000 },
        { name = "nvim_lsp", priority = 900 },
        { name = "nvim_lua", priority = 800 },
        { name = "luasnip", priority = 700 },
        { name = "buffer", priority = 600 },
        { name = "path", priority = 500 },
      },
    })
  end,
}

return M
