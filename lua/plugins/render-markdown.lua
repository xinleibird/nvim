local M = {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "codecompanion", "mdx" },
    opts = {
      file_types = { "markdown", "codecompanion", "mdx" },
      latex = { enabled = false },
      completions = { blink = { enabled = true } },
    },
  },
}

return M
