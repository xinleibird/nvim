local M = {
  "nvim-tree/nvim-web-devicons",
  dependencies = {
    "rachartier/tiny-devicons-auto-colors.nvim",
    config = function()
      local theme_colors = require("catppuccin.palettes").get_palette()
      require("tiny-devicons-auto-colors").setup({
        colors = theme_colors,
        autoreload = true,
      })
    end,
  },
}

return M
