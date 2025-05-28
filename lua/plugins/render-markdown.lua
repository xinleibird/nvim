local M = {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion", "mdx" },
    opts = {
      file_types = { "markdown", "codecompanion", "mdx" },
      latex = { enabled = false },
      completions = { blink = { enabled = true } },
    },
  },
}

return M
