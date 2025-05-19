local M = {
  -- Make sure to set this up properly if you have lazy=true
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = { "markdown", "Avante", "codecompanion" },
  },
  ft = { "markdown", "Avante", "codecompanion" },
  config = function()
    require("render-markdown").setup({
      latex = { enabled = false },
      completions = { blink = { enabled = true } },
    })
  end,
}

return M
