local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
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
          mantle = "#f0ebce",
          crust = "#e8e3c8",
          subtext1 = "#73503c",
          subtext0 = "#805942",
          overlay2 = "#8c6249",
          overlay1 = "#8c856d",
          overlay0 = "#a69d81",
          surface2 = "#bfb695",
          surface1 = "#d1c7a3",
          surface0 = "#e3dec3",
          text = "#654735",
          base = "#f9f5d7",
        },
        mocha = {
          rosewater = "#ea6962",
          flamingo = "#ea6962",
          red = "#ea6962",
          maroon = "#ea6962",
          pink = "#d3869b",
          mauve = "#d3869b",
          peach = "#e78a4e",
          yellow = "#d8a657",
          green = "#a9b665",
          teal = "#89b482",
          sky = "#89b482",
          sapphire = "#89b482",
          blue = "#7daea3",
          lavender = "#7daea3",
          mantle = "#191b1c",
          crust = "#141617",
          subtext1 = "#d5c4a1",
          subtext0 = "#bdae93",
          overlay2 = "#a89984",
          overlay1 = "#928374",
          overlay0 = "#595959",
          surface2 = "#4d4d4d",
          surface1 = "#404040",
          surface0 = "#292929",
          text = "#ebdbb2",
          base = "#1d2021",
        },
      },
      highlight_overrides = {
        all = function(C)
          local colors = require("catppuccin.utils.colors")
          return {
            -- Hints
            ActionHintsDefinition = { fg = C.yellow },
            ActionHintsReferences = { fg = C.blue },

            -- Illuminated
            -- IlluminatedWordText = { underdashed = true },
            -- IlluminatedWordRead = { underdashed = true },
            -- IlluminatedWordWrite = { underdashed = true },

            Visual = { bg = C.overlay2, fg = C.text, bold = true },
            VisualNOS = { bg = C.overlay2, fg = C.text, bold = true },

            -- All separator
            WinSeparator = { fg = C.mauve },

            -- Outline
            OutlineDetails = { link = "Comment" },
            OutlineGuides = { fg = C.mantle },

            -- CursorLine highlight
            CursorLine = {
              bg = colors.vary_color(
                { latte = colors.lighten(C.mantle, 0.6, C.base) },
                colors.darken(C.surface0, 0.6, C.base)
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
            SnacksPickerInputBorder = {
              bg = colors.vary_color(
                { latte = colors.lighten(C.sapphire, 0.6, C.base) },
                colors.darken(C.sapphire, 0.2, C.base)
              ),
              fg = colors.vary_color(
                { latte = colors.lighten(C.sapphire, 0.6, C.base) },
                colors.darken(C.sapphire, 0.2, C.base)
              ),
            },
            SnacksPickerInputTitle = { bg = C.blue, fg = C.base, bold = true },
            SnacksPickerList = { bg = C.crust },
            SnacksPickerListBorder = { bg = C.crust, fg = C.crust },
            SnacksPickerListCursorLine = { bg = C.surface0 },
            SnacksPickerPreviewBorder = { bg = C.mantle, fg = C.mantle },
            SnacksPickerPrompt = { bg = C.mantle, fg = C.text },
          }
        end,
      },
      custom_highlights = function(C)
        local colors = require("catppuccin.utils.colors")
        return {

          -- Snacks Dashboard logo and reflection
          SnacksDashboardHeader = { fg = colors.darken(C.red, 0.8) },
          SnacksDashboardHeaderReflection = {
            fg = colors.vary_color({ latte = colors.lighten(C.text, 0.1, C.base) }, colors.darken(C.text, 0.1, C.base)),
          },
        }
      end,
      default_integrations = true,
      integrations = {
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
        fidget = true,
        flash = true,
        fzf = true,
        illuminate = {
          enabled = true,
          lsp = true,
        },
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
        nvim_surround = true,
        symbols_outline = true,
        semantic_tokens = true,
        snacks = {
          enabled = true,
          indent_scope_color = "surface2",
        },
        telescope = {
          enabled = true,
          style = "nvchad",
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
