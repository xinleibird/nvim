---@module "lazy"
---@type LazySpec
local M = {
  "hedyhli/outline.nvim",
  event = { "BufRead", "BufNewFile", "User SnacksDashboardClosed" },
  config = function()
    local icons = require("configs.icons").lspkind
    require("outline").setup({
      outline_window = {
        position = "right",
        width = 28,
        relative_width = false,
        focus_on_open = false,
        jump_highlight_duration = false,
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

    vim.keymap.set("n", "<leader>o", function()
      require("outline").toggle()
    end, { desc = "Toggle outline" })
  end,
}

return M
