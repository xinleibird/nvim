local M = {
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
    return {
      ActionHintsDefinition = { fg = colors.yellow },
      ActionHintsReferences = { fg = colors.blue },
      EyelinerPrimary = { fg = colors.peach, style = { "bold", "underline" } },
      EyelinerSecondary = { fg = colors.sky, style = { "bold" } },

      IlluminatedWordRead = { bg = colors.crust },
      IlluminatedWordText = { bg = colors.crust },
      IlluminatedWordWrite = { bg = colors.crust },
      -- IlluminatedWordRead = { bg = "none", underdotted = true },
      -- IlluminatedWordText = { bg = "none", underdotted = true },
      -- IlluminatedWordWrite = { bg = "none", underdotted = true },

      IblScope = { fg = colors.surface2 },

      VirtColumn = { fg = colors.surface0 },

      OutlineDetails = { link = "Comment" },
      OutlineGuides = { fg = colors.mantle },

      CmpItemAbbr = { fg = colors.text },
      CmpItemAbbrMatch = { fg = colors.blue, bold = true },
      CmpItemMenu = { fg = colors.base, italic = true },
      CmpDoc = { bg = colors.crust },
      CmpDocBorder = { fg = colors.crust, bg = colors.crust },
      CmpPmenu = { bg = colors.mantle },
      CmpSel = { link = "PmenuSel", bold = true },

      -- NvimTree under cursor highlight
      CursorLine = { bg = colors.crust },

      -- NvimTree under cursor highlight
      TelescopeSelection = { bg = colors.crust },

      ToggleTermBg = { bg = colors.base },
    }
  end,
  integrations = {
    alpha = true,
    cmp = true,
    dap = true,
    dap_ui = true,
    dashboard = true,
    fidget = true,
    gitsigns = true,
    hop = true,
    ---@diagnostic disable-next-line: assign-type-mismatch
    illuminate = {
      enabled = true,
      lsp = true,
    },
    indent_blankline = {
      enabled = true,
      scope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
      colored_indent_levels = false,
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
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
      },
      inlay_hints = {
        background = true,
      },
    },
    notify = true,
    nvimtree = true,
    symbols_outline = true,
    semantic_tokens = true,
    telescope = {
      enabled = true,
      style = "nvchad",
    },
    treesitter = true,
    which_key = true,
  },
}

return M
