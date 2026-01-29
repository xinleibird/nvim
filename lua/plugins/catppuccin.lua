---@diagnostic disable: undefined-field
local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("catppuccin").setup({
      flavour = "auto", -- latte, frappe, macchiato, mocha, auto
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
      no_underline = false, -- Force no underline
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = { "bold" },
        functions = { "bold" },
        keywords = { "bold" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = { "italic" },
        types = {},
        operators = {},
        miscs = {},
      },
      lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
          ok = { "italic" },
        },
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
          ok = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      color_overrides = {
        latte = {
          rosewater = "#c14a4a",
          flamingo = "#c14a4a",
          red = "#c14a4a",
          maroon = "#c14a4a",
          pink = "#945e80",
          mauve = "#945e80",
          peach = "#c35e0a",
          yellow = "#b47109",
          green = "#6c782e",
          teal = "#4c7a5d",
          sky = "#4c7a5d",
          sapphire = "#4c7a5d",
          blue = "#45707a",
          lavender = "#45707a",
          text = "#654735",
          subtext1 = "#73503c",
          subtext0 = "#805942",
          overlay2 = "#8c6249",
          overlay1 = "#8c856d",
          overlay0 = "#a69d81",
          surface2 = "#bfb695",
          surface1 = "#d1c7a3",
          surface0 = "#e3dec3",
          base = "#f9f5d7",
          mantle = "#f0ebce",
          crust = "#e8e3c8",
        },
        mocha = {
          rosewater = "#ea6962",
          flamingo = "#ea6962",
          pink = "#d3869b",
          mauve = "#d3869b",
          red = "#ea6962",
          maroon = "#ea6962",
          peach = "#e78a4e",
          yellow = "#d8a657",
          green = "#a9b665",
          teal = "#89b482",
          sky = "#89b482",
          sapphire = "#89b482",
          blue = "#7daea3",
          lavender = "#7daea3",
          text = "#ebdbb2",
          subtext1 = "#d5c4a1",
          subtext0 = "#bdae93",
          overlay2 = "#a89984",
          overlay1 = "#928374",
          overlay0 = "#595959",
          surface2 = "#4d4d4d",
          surface1 = "#404040",
          surface0 = "#292929",
          base = "#1d2021",
          mantle = "#191b1c",
          crust = "#141617",
        },
      },
      highlight_overrides = {},
      custom_highlights = function(C)
        local colors = require("catppuccin.utils.colors")
        return {
          -- Comment
          Comment = { fg = C.overlay0 },

          -- Hints
          ActionHintsDefinition = { fg = C.yellow },
          ActionHintsReferences = { fg = C.blue },

          -- All separator
          WinSeparator = { fg = C.mauve },

          -- Outline
          OutlineDetails = { link = "Comment" },
          OutlineGuides = { fg = C.mantle },

          -- CursorLine highlight
          CursorLine = {
            bg = colors.vary_color(
              { latte = colors.lighten(C.surface0, 0.4, C.base) },
              colors.darken(C.surface0, 0.5, C.base)
            ),
          },

          -- Window Picker
          WindowPickerStatusLine = { bg = C.crust, fg = C.base, bold = true },
          WindowPickerStatusLineNC = { bg = C.blue, fg = C.base, bold = true },

          -- Bufferline Picker
          BufferLinePickVisible = { bg = C.base, fg = C.red, bold = true },
          BufferLinePick = { bg = C.base, fg = C.red, bold = true },
          BufferLinePickSelected = { fg = C.overlay0, bg = C.base, bold = true, italic = true },

          -- Snacks
          SnacksPickerBoxTitle = { bg = C.blue, fg = C.base, bold = true },
          SnacksPickerInput = { bg = C.mantle, fg = C.text },
          SnacksPickerInputBorder = { fg = C.yellow },
          SnacksPickerInputTitle = { bg = C.blue, fg = C.base, bold = true },
          SnacksPickerList = { bg = C.crust },
          SnacksPickerListBorder = { bg = C.crust, fg = C.crust },
          -- SnacksPickerListCursorLine = { bg = colors.lighten(C.overlay0, 0.3, C.base) },
          SnacksPickerListCursorLine = {
            bg = colors.lighten(C.overlay2, 0.2, C.base),
          },
          SnacksPickerPreviewBorder = { bg = C.mantle, fg = C.mantle },
          SnacksPickerPrompt = { bg = C.mantle, fg = C.text },
          SnacksIndentScope = {
            fg = colors.vary_color({ latte = colors.lighten(C.red, 0.6, C.base) }, colors.darken(C.red, 0.3, C.base)),
          },

          -- Snacks Dashboard logo and reflection
          SnacksDashboardHeader = { fg = colors.darken(C.red, 0.8) },
          SnacksDashboardHeaderReflection = {
            fg = colors.vary_color({ latte = colors.lighten(C.text, 0.1, C.base) }, colors.darken(C.text, 0.1, C.base)),
          },

          -- Fold
          Folded = { bg = C.surface0, fg = C.text },
        }
      end,
      default_integrations = false,
      integrations = {
        barbecue = {
          dim_dirname = true, -- directory name is dimmed by default
          bold_basename = true,
          dim_context = false,
          alt_background = false,
        },
        blink_cmp = {
          enabled = true,
          style = "bordered",
        },
        dap = true,
        dap_ui = true,
        fidget = true,
        flash = true,
        fzf = true,
        markdown = true,
        mason = true,
        mini = {
          enabled = true,
          indentscope_color = "surface1", -- catppuccin color (eg. `lavender`) Default: text
        },
        nvim_surround = true,
        symbols_outline = true,
        semantic_tokens = true,
        snacks = {
          enabled = true,
          indent_scope_color = "surface2",
        },
        treesitter = true,
        treesitter_context = true,
        render_markdown = true,
        which_key = true,
      },
    })
  end,
}

return M
