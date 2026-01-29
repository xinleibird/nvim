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
      anti_conceal = {
        -- This enables hiding added text on the line the cursor is on.
        enabled = false,
      },
      completions = { lsp = { enabled = true } },
      code = {
        border = "thick",
      },
    },
  },
}

return M
