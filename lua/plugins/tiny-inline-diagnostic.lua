local M = {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "BufEnter *.*",
  config = function()
    require("tiny-inline-diagnostic").setup({
      options = {
        multilines = {
          enabled = true,
        },
        show_source = {
          enabled = false,
        },
      },
      signs = {
        diag = "🐱",
      },
    })
  end,
}

return M
