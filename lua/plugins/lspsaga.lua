local M = {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    local icons = require("configs.icons").lspkind
    return {
      lightbulb = { enable = false },
      ui = {
        kind = {
          File = { icons.File .. " ", "LspKindFile" },
          Module = { icons.Module .. " ", "LspKindModule" },
          Namespace = { icons.Namespace .. " ", "LspKindNamespace" },
          Package = { icons.Package .. " ", "LspKindPackage" },
          Class = { icons.Class .. " ", "LspKindClass" },
          Method = { icons.Method .. " ", "LspKindMethod" },
          Property = { icons.Property .. " ", "LspKindProperty" },
          Field = { icons.Field .. " ", "LspKindField" },
          Constructor = { icons.Constructor .. " ", "LspKindConstructor" },
          Enum = { icons.Enum .. " ", "LspKindEnum" },
          Interface = { icons.Interface .. " ", "LspKindInterface" },
          Function = { icons.Function .. " ", "LspKindFunction" },
          Variable = { icons.Variable .. " ", "LspKindVariable" },
          Constant = { icons.Constant .. " ", "LspKindConstant" },
          String = { icons.String .. " ", "LspKindString" },
          Number = { icons.Number .. " ", "LspKindNumber" },
          Boolean = { icons.Boolean .. " ", "LspKindBoolean" },
          Array = { icons.Array .. " ", "LspKindArray" },
          Object = { icons.Object .. " ", "LspKindObject" },
          Key = { icons.Key .. " ", "LspKindKey" },
          Null = { icons.Null .. " ", "LspKindNull" },
          EnumMember = { icons.EnumMember .. " ", "LspKindEnumMember" },
          Struct = { icons.Struct .. " ", "LspKindStruct" },
          Event = { icons.Event .. " ", "LspKindEvent" },
          Operator = { icons.Operator .. " ", "LspKindOperator" },
          TypeParameter = { icons.TypeParameter .. " ", "LspKindTypeParameter" },
          TypeAlias = { icons.Alias .. " ", "LspKindTypeAlias" },
          Parameter = { icons.TypeParameter .. " ", "LspKindParameter" },
          StaticMethod = { icons.Method .. " ", "LspKindStaticMethod" },
          Macro = { icons.Macro .. " ", "LspKindMacro" },

          Text = { icons.Text .. " ", "LspKindText" },
          Snippet = { icons.Snippet .. " ", "LspKindSnippet" },
          Folder = { icons.Folder .. " ", "LspKindFolder" },
          Unit = { icons.Unit .. " ", "LspKindUnit" },
          Value = { icons.Value .. " ", "LspKindValue" },
        },
      },
    }
  end,
  config = function(_, opts)
    require("lspsaga").setup(opts)
  end,
}

return M
