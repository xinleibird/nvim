local cmp = require("cmp")
local icons = require("core.configs.icons")
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

local M = {
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
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
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
    { name = "luasnip", priority = 900 },
    { name = "nvim_lsp", priority = 800 },
    { name = "nvim_lua", priority = 700 },
    { name = "buffer", priority = 600 },
    { name = "path", priority = 500 },
  },
}

return M
