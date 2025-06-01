local M = {
  "BrunoKrugel/bbq.nvim",
  name = "barbecue",
  event = "LspAttach",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    vim.api.nvim_create_autocmd({
      "WinScrolled",
      "BufWinEnter",
      "CursorHold",
      "InsertLeave",
      "BufModifiedSet",
    }, {
      group = vim.api.nvim_create_augroup("barbecue.updater", { clear = true }),
      callback = function()
        require("barbecue.ui").update()
      end,
    })
  end,
  config = function()
    require("barbecue").setup({
      create_autocmd = false,

      theme = {
        -- these highlights are used for context/navic icons
        context_file = { link = "LspKindFile" },
        context_module = { link = "LspKindModule" },
        context_namespace = { link = "LspKindNamespace" },
        context_package = { link = "LspKindPackage" },
        context_class = { link = "LspKindClass" },
        context_method = { link = "LspKindMethod" },
        context_property = { link = "LspKindProperty" },
        context_field = { link = "LspKindField" },
        context_constructor = { link = "LspKindConstructor" },
        context_enum = { link = "LspKindEnum" },
        context_interface = { link = "LspKindInterface" },
        context_function = { link = "LspKindFunction" },
        context_variable = { link = "LspkindVariable" },
        context_constant = { link = "LspKindConstant" },
        context_string = { link = "LspKindString" },
        context_number = { link = "LspKindNumber" },
        context_boolean = { link = "LspKindBoolean" },
        context_array = { link = "LspKindArray" },
        context_object = { link = "LspKindObject" },
        context_key = { link = "LspKindKey" },
        context_null = { link = "LspKindNull" },
        context_enum_member = { link = "LspKindEnumMember" },
        context_struct = { link = "LspKindStruct" },
        context_event = { link = "LspKindEvent" },
        context_operator = { link = "LspKindOperator" },
        context_type_parameter = { link = "LspKindTypeParameter" },

        -- normal = { fg = "#c0caf5" },

        -- these highlights correspond to symbols table from config
        ellipsis = { link = "LspKindFolder" },
        separator = { link = "LspKindFolder" },
        modified = { link = "LspKindFolder" },
        diagnostics = { fg = "#ff0000" },

        -- these highlights represent the _text_ of three main parts of barbecue
        dirname = { link = "LspKindFolder" },
        basename = { bold = true },
        context = {},
      },

      symbols = {
        modified = require("configs.icons").ui.Modified,
        ellipsis = require("configs.icons").ui.Ellipsis,
        separator = require("configs.icons").ui.ChevronRight,
      },
      kinds = require("configs.icons").lspkind,

      exclude_filetypes = { "netrw", "FTerm", "snacks_layout_box", "nvim-dap-view" },
    })
  end,
}

return M
