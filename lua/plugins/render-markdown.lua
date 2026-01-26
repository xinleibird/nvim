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
      latex = { enabled = false },
      completions = { lsp = { enabled = true } },
      code = {
        border = "thick",
      },
    },
  },
}

return M
