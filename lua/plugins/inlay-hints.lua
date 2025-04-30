local M = {
  "MysticalDevil/inlay-hints.nvim",
  event = { "LspAttach", "BufWinEnter" },
  config = function()
    require("inlay-hints").setup()
  end,
}

return M
