local M = {
  "nvim-tree/nvim-web-devicons",
  dependencies = {
    "rachartier/tiny-devicons-auto-colors.nvim",
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "catppuccin*",
        group = vim.api.nvim_create_augroup("user_tiny_devicons_reload", { clear = true }),
        callback = function()
          local theme_colors = require("catppuccin.palettes").get_palette()
          require("tiny-devicons-auto-colors").apply(theme_colors)
        end,
      })
    end,
    config = function()
      require("tiny-devicons-auto-colors").setup({
        ignore = {},
        autoreload = false,
      })
    end,
  },
}

return M
