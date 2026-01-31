local M = {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "codecompanion" },
    opts = {
      file_types = { "markdown", "codecompanion" },
      render_modes = true,
      anti_conceal = {
        -- This enables hiding added text on the line the cursor is on.
        enabled = true,
      },
      completions = {
        lsp = { enabled = true },
      },
      code = {
        border = "thick",
      },
      heading = {
        sign = true,
      },
      checkbox = {
        enabled = true,
      },
    },
  },
}

return M
