local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      -- flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      transparent_background = false,
      show_end_of_buffer = false, -- show the '~' characters after the end of buffers
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.62,
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = { "bold" },
        functions = {},
        keywords = { "bold" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = { "italic" },
        types = {},
        operators = {},
      },
      color_overrides = {},
      highlight_overrides = {},
      custom_highlights = function(colors)
        local util = require("catppuccin.utils.colors")
        return {
          ActionHintsDefinition = { fg = colors.yellow },
          ActionHintsReferences = { fg = colors.blue },

          EyelinerPrimary = { fg = colors.peach, style = { "bold", "underline" } },
          EyelinerSecondary = { fg = colors.sky, style = { "bold" } },

          -- Illuminated
          -- IlluminatedWordRead = { fg = colors.mauve, bg = colors.crust, underdotted = true },
          -- IlluminatedWordText = { fg = colors.mauve, bg = colors.crust, underdotted = true },
          -- IlluminatedWordWrite = { fg = colors.mauve, bg = colors.crust, underdotted = true },

          WinSeparator = { fg = colors.lavender },
          NeoTreeWinSeparator = { fg = colors.lavender },
          VirtColumn = { fg = colors.mantle },

          OutlineDetails = { link = "Comment" },
          OutlineGuides = { fg = colors.mantle },

          CmpItemAbbr = { fg = colors.text },
          CmpItemAbbrMatch = { fg = colors.blue, bold = true },
          CmpItemMenu = { fg = colors.base, italic = true },
          CmpDoc = { bg = colors.crust },
          CmpDocBorder = { fg = colors.crust, bg = colors.crust },
          CmpPmenu = { bg = colors.mantle },
          CmpSel = { link = "PmenuSel", bold = true },

          -- CursorLine highlight
          -- CursorLine = { bg = colors.crust },
          CursorLine = {
            bg = util.vary_color(
              { latte = util.lighten(colors.mantle, 0.6, colors.base) },
              util.darken(colors.surface0, 0.5, colors.base)
            ),
          },
          NeoTreeCursorLine = {
            bg = util.vary_color(
              { latte = util.lighten(colors.mantle, 0.2, colors.base) },
              util.darken(colors.surface0, 0.3, colors.base)
            ),
          },

          -- Trouble
          TroubleNormal = { bg = colors.base },
          TroubleNormalNC = { bg = colors.base },

          -- NeoTree header style
          NeoTreeHeaderAndTitle = { bg = colors.crust, bold = true },

          -- Telescope under cursor highlight
          TelescopeSelection = { bg = colors.crust },

          -- Window Picker
          WindowPickerStatusLine = { bg = colors.crust, fg = colors.base, bold = true },
          WindowPickerStatusLineNC = { bg = colors.blue, fg = colors.base, bold = true },

          -- DevIconJs = { fg = colors.yellow },
          -- DevIconTs = { fg = colors.blue },

          -- Bufferline Picker
          BufferLinePickVisible = { bg = colors.base, fg = colors.red, bold = true },
          BufferLinePick = { bg = colors.base, fg = colors.red, bold = true },
          BufferLinePickSelected = { fg = colors.overlay0, bg = colors.base, bold = true, italic = true },

          -- FloatBorder
          FloatBorder = { fg = colors.rosewater, bg = colors.none },
        }
      end,
      default_integrations = true,
      integrations = {
        alpha = true,
        barbecue = {
          dim_dirname = true, -- directory name is dimmed by default
          bold_basename = true,
          dim_context = false,
          alt_background = false,
        },
        blink_cmp = true,
        cmp = true,
        dap = true,
        dap_ui = true,
        dashboard = true,
        diffview = true,
        fidget = true,
        flash = true,
        fzf = true,
        gitsigns = true,
        illuminate = {
          enabled = true,
          lsp = true,
        },
        indent_blankline = {
          enabled = true,
          scope_color = "surface2", -- catppuccin color (eg. `lavender`) Default: text
          colored_indent_levels = false,
        },
        lsp_trouble = false,
        markdown = true,
        mason = true,
        mini = {
          enabled = true,
          indentscope_color = "surface1", -- catppuccin color (eg. `lavender`) Default: text
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            hints = { "italic" },
          },
          underlines = {
            errors = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
            hints = { "undercurl" },
          },
          inlay_hints = {
            background = true,
          },
        },
        neogit = true,
        neotree = true,
        notify = true,
        nvim_surround = true,

        symbols_outline = true,
        semantic_tokens = true,
        snacks = {
          enabled = true,
          indent_scope_color = "lavender",
        },
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        treesitter = true,
        which_key = true,
      },
    })
  end,
}

return M
