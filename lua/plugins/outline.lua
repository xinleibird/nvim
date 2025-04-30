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
          File = { icon = icons.File, hl = "LspKindFile" },
          Module = { icon = icons.Module, hl = "LspKindModule" },
          Namespace = { icon = icons.Namespace, hl = "LspKindNamespace" },
          Package = { icon = icons.Package, hl = "LspKindPackage" },
          Class = { icon = icons.Class, hl = "LspKindClass" },
          Method = { icon = icons.Method, hl = "LspKindMethod" },
          Property = { icon = icons.Property, hl = "LspKindProperty" },
          Field = { icon = icons.Field, hl = "LspKindField" },
          Constructor = { icon = icons.Constructor, hl = "LspKindConstructor" },
          Enum = { icon = icons.Enum, hl = "LspKindEnum" },
          Interface = { icon = icons.Interface, hl = "LspKindInterface" },
          Function = { icon = icons.Function, hl = "LspKindFunction" },
          Variable = { icon = icons.Variable, hl = "LspKindVariable" },
          Constant = { icon = icons.Constant, hl = "LspKindConstant" },
          String = { icon = icons.String, hl = "LspKindString" },
          Number = { icon = icons.Number, hl = "LspKindNumber" },
          Boolean = { icon = icons.Boolean, hl = "LspKindBoolean" },
          Array = { icon = icons.Array, hl = "LspKindArray" },
          Object = { icon = icons.Object, hl = "LspKindObject" },
          Key = { icon = icons.Key, hl = "LspKindKey" },
          Null = { icon = icons.Null, hl = "LspKindNull" },
          EnumMember = { icon = icons.EnumMember, hl = "LspKindEnumMember" },
          Struct = { icon = icons.Struct, hl = "LspKindStruct" },
          Event = { icon = icons.Event, hl = "LspKindEvent" },
          Operator = { icon = icons.Operator, hl = "LspKindOperator" },
          TypeParameter = { icon = icons.TypeParameter, hl = "LspKindTypeParameterIdentifier" },
          TypeAlias = { icon = icons.Alias, hl = "LspKindTypeAlias" },
          Parameter = { icon = icons.TypeParameter, hl = "LspKindParameter" },
          StaticMethod = { icon = icons.Method, hl = "LspKindStaticMethod" },
          Macro = { icon = icons.Macro, hl = "LspKindMacro" },

          Component = { icon = icons.Component, hl = "LspKindFunction" },
          Fragment = { icon = icons.Fragment, hl = "LspKindConstant" },
        },
      },
    })
  end,
}

return M
