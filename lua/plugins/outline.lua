local M = {
  "hedyhli/outline.nvim",
  event = "FileReadPre",
  init = function()
    vim.keymap.set("n", "<leader>o", "<cmd>silent! Outline<CR>", { desc = "Toggle outline" })
  end,
  config = function()
    local icons = require("configs.icons").lspkind
    require("outline").setup({
      outline_window = {
        position = "right",
        width = 27,
        relative_width = false,
        focus_on_open = true,
        jump_highlight_duration = false,
      },
      outline_items = {
        -- Show extra details with the symbols (lsp dependent) as virtual next
        show_symbol_details = true,
        -- Show corresponding line numbers of each symbol on the left column as
        -- virtual text, for quick navigation when not focused on outline.
        -- Why? See this comment:
        -- https://github.com/simrat39/symbols-outline.nvim/issues/212#issuecomment-1793503563
        show_symbol_lineno = false,
        -- Whether to highlight the currently hovered symbol and all direct parents
        highlight_hovered_item = true,
        -- Whether to automatically set cursor location in outline to match
        -- location in code when focus is in code. If disabled you can use
        -- `:OutlineFollow[!]` from any window or `<C-g>` from outline window to
        -- trigger this manually.
        auto_set_cursor = true,
        -- Autocmd events to automatically trigger these operations.
        auto_update_events = {
          -- Includes both setting of cursor and highlighting of hovered item.
          -- The above two options are respected.
          -- This can be triggered manually through `follow_cursor` lua API,
          -- :OutlineFollow command, or <C-g>.
          follow = { "CursorMoved" },
          -- Re-request symbols from the provider.
          -- This can be triggered manually through `refresh_outline` lua API, or
          -- :OutlineRefresh command.
          items = { "InsertLeave", "WinEnter", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost" },
        },
      },
      symbols = {
        icons = {
          File = { icon = icons.File, hl = "Identifier" },
          Module = { icon = icons.Module, hl = "Include" },
          Namespace = { icon = icons.Namespace, hl = "Include" },
          Package = { icon = icons.Package, hl = "Include" },
          Class = { icon = icons.Class, hl = "Type" },
          Method = { icon = icons.Method, hl = "Function" },
          Property = { icon = icons.Property, hl = "Identifier" },
          Field = { icon = icons.Field, hl = "Identifier" },
          Constructor = { icon = icons.Constructor, hl = "Special" },
          Enum = { icon = icons.Enum, hl = "Type" },
          Interface = { icon = icons.Interface, hl = "Type" },
          Function = { icon = icons.Function, hl = "Function" },
          Variable = { icon = icons.Variable, hl = "Constant" },
          Constant = { icon = icons.Constant, hl = "Constant" },
          String = { icon = icons.String, hl = "String" },
          Number = { icon = icons.Number, hl = "Number" },
          Boolean = { icon = icons.Boolean, hl = "Boolean" },
          Array = { icon = icons.Array, hl = "Constant" },
          Object = { icon = icons.Object, hl = "Type" },
          Key = { icon = icons.Key, hl = "Type" },
          Null = { icon = icons.Null, hl = "Type" },
          EnumMember = { icon = icons.EnumMember, hl = "Identifier" },
          Struct = { icon = icons.Struct, hl = "Structure" },
          Event = { icon = icons.Event, hl = "Type" },
          Operator = { icon = icons.Operator, hl = "Identifier" },
          TypeParameter = { icon = icons.TypeParameter, hl = "Identifier" },
          Component = { icon = icons.Component, hl = "Function" },
          Fragment = { icon = icons.Fragment, hl = "Constant" },
          TypeAlias = { icon = icons.Alias, hl = "Type" },
          Parameter = { icon = icons.TypeParameter, hl = "Identifier" },
          StaticMethod = { icon = icons.Method, hl = "Function" },
          Macro = { icon = icons.Macro, hl = "Function" },
        },
      },
    })
  end,
}

return M
