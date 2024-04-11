local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = "VimEnter",
  opts = {
    indent = { char = "▏", highlight = "IblIndent" },
    scope = { char = "▏", highlight = "IblScope" },
    whitespace = { highlight = "IblWhitespace" },
  },
  config = function(_, opts)
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    require("ibl").setup(opts)
  end,
}

return M
