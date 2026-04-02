---@module "lazy"
---@type LazySpec
local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  dependencies = {
    "vimpostor/vim-lumen",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = { "LumenLight", "LumenDark" },
        group = vim.api.nvim_create_augroup("user_lumen_toggle_dark_mode", { clear = true }),
        callback = function()
          if vim.bo.filetype == "snacks_dashboard" then
            if vim.g.lumen_dashboard_update_count > 0 then
              require("snacks").dashboard.update()
            end
          end
          -- configs/options : vim.g.lumen_dashboard_update_count
          vim.g.lumen_dashboard_update_count = vim.g.lumen_dashboard_update_count + 1
        end,
      })
    end,
  },
  config = function()
    require("catppuccin").setup({
      flavour = "auto", -- latte, frappe, macchiato, mocha, auto
      background = {
        light = "latte",
        dark = "mocha",
      },
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      transparent_background = false,
      float = {
        transparent = false, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
      },
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
        -- strings = {},
        -- variables = {},
        -- numbers = {},
        -- booleans = {},
        properties = { "italic" },
        -- types = {},
        -- operators = {},
        -- miscs = {},
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
          pink = "#945e80",
          mauve = "#945e80",
          red = "#c14a4a",
          maroon = "#c14a4a",
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
          -- WinSeparator = { fg = C.crust },
          WinSeparator = {
            -- fg = C.crust,
            fg = colors.vary_color({ latte = C.surface1 }, C.crust),
          },

          -- Outline
          OutlineDetails = { link = "Comment" },
          OutlineGuides = {
            -- fg = C.mantle,
            fg = colors.vary_color({ latte = C.surface0 }, C.mantle),
          },

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

          -- Snacks Dashboard logo and reflection
          SnacksDashboardHeader = { fg = colors.darken(C.red, 0.8) },
          SnacksDashboardHeaderReflection = {
            fg = colors.vary_color({ latte = colors.lighten(C.text, 0.1, C.base) }, colors.darken(C.text, 0.1, C.base)),
          },

          SnacksPickerPrompt = { bg = C.mantle, fg = C.text },

          -- Edgy
          EdgyNormal = { bg = C.base },

          -- CodeCompanion Chat Normal
          CodeCompanionNormal = { bg = C.base },
          CodeCompanionBorder = { bg = C.base },

          -- BlinkIndent
          BlinkIndent = {
            fg = colors.vary_color({ latte = C.surface0 }, C.mantle),
          },

          BlinkIndentRed = {
            fg = colors.vary_color({ latte = colors.lighten(C.red, 0.6, C.base) }, colors.darken(C.red, 0.3, C.base)),
          },
          BlinkIndentYellow = {
            fg = colors.vary_color(
              { latte = colors.lighten(C.yellow, 0.6, C.base) },
              colors.darken(C.yellow, 0.3, C.base)
            ),
          },
          BlinkIndentBlue = {
            fg = colors.vary_color({ latte = colors.lighten(C.blue, 0.6, C.base) }, colors.darken(C.blue, 0.3, C.base)),
          },
          BlinkIndentOrange = {
            fg = colors.vary_color(
              { latte = colors.lighten(C.peach, 0.6, C.base) },
              colors.darken(C.peach, 0.3, C.base)
            ),
          },
          BlinkIndentGreen = {
            fg = colors.vary_color(
              { latte = colors.lighten(C.green, 0.6, C.base) },
              colors.darken(C.green, 0.3, C.base)
            ),
          },
          BlinkIndentViolet = {
            fg = colors.vary_color(
              { latte = colors.lighten(C.mauve, 0.6, C.base) },
              colors.darken(C.mauve, 0.3, C.base)
            ),
          },
          BlinkIndentCyan = {
            fg = colors.vary_color({ latte = colors.lighten(C.text, 0.6, C.base) }, colors.darken(C.text, 0.3, C.base)),
          },

          -- BlinkCmp
          BlinkCmpMenuBorder = { link = "FloatBorder" },

          -- Fold
          Folded = { bg = C.surface0, fg = C.text },

          -- Lualine
          LualineLsp = { bg = C.surface0, fg = C.lavender },
          LualineFiletype = { bg = C.surface0 },

          -- Lualine CodeCompanion
          LualineCodeCompanionActive = { bg = C.surface0, fg = C.red },
          LualineCodeCompanionInactive = { bg = C.surface0, fg = C.overlay0 },

          -- Lualine Lsp
          LualineLspActive = { bg = C.surface0, fg = C.yellow },
          LualineLspInactive = { bg = C.surface0, fg = C.overlay0 },

          -- LSP
          LspKindClass = { fg = C.yellow },
          LspKindConstant = { fg = C.peach },
          LspKindConstructor = { fg = C.sapphire },
          LspKindEnum = { fg = C.yellow },
          LspKindEnumMember = { fg = C.teal },
          LspKindEvent = { fg = C.yellow },
          LspKindField = { fg = C.teal },
          LspKindFile = { fg = C.rosewater },
          LspKindFunction = { fg = C.blue },
          LspKindInterface = { fg = C.yellow },
          LspKindKey = { fg = C.red },
          LspKindMethod = { fg = C.blue },
          LspKindModule = { fg = C.blue },
          LspKindNamespace = { fg = C.blue },
          LspKindNumber = { fg = C.peach },
          LspKindOperator = { fg = C.sky },
          LspKindPackage = { fg = C.blue },
          LspKindProperty = { fg = C.teal },
          LspKindStruct = { fg = C.yellow },
          LspKindTypeParameter = { fg = C.blue },
          LspKindVariable = { fg = C.peach },
          LspKindArray = { fg = C.peach },
          LspKindBoolean = { fg = C.peach },
          LspKindNull = { fg = C.yellow },
          LspKindObject = { fg = C.yellow },
          LspKindString = { fg = C.green },
          -- ccls-specific icons.
          LspKindTypeAlias = { fg = C.green },
          LspKindParameter = { fg = C.blue },
          LspKindStaticMethod = { fg = C.peach },
          -- Microsoft-specific icons.
          LspKindText = { fg = C.green },
          LspKindSnippet = { fg = C.mauve },
          LspKindFolder = { fg = C.blue },
          LspKindUnit = { fg = C.green },
          LspKindValue = { fg = C.peach },

          ModesCopy = { bg = C.peach },
          ModesDelete = { bg = C.red },
          ModesChange = { bg = C.red },
          ModesFormat = { bg = C.yellow },
          ModesInsert = { bg = C.green },
          ModesReplace = { bg = C.red },
          ModesSelect = { bg = C.red },
          ModesVisual = { bg = C.pink },
          Cursor = { bg = C.yellow },
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
        blink_indent = true,
        blink_pairs = true,
        dap = true,
        dap_ui = true,
        flash = true,
        fzf = true,
        mason = true,
        mini = {
          enabled = true,
          indentscope_color = "surface1", -- catppuccin color (eg. `lavender`) Default: text
        },
        nvim_surround = true,
        symbols_outline = true,
        snacks = {
          enabled = true,
          indent_scope_color = "surface2",
        },
        render_markdown = true,
        which_key = true,
      },
    })

    -- colorscheme
    vim.cmd.colorscheme("catppuccin-nvim")
  end,
}

return M
