local M = {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    opts = {
      file_types = { "markdown", "codecompanion" },
      latex = { enabled = false },
      completions = { blink = { enabled = true } },
    },
  },
}

return M
