local M = {
  "rcarriga/nvim-notify",
  priority = 1000,
  event = "VimEnter",
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("notify").setup({
      render = "default",
      timeout = 2000,
      stages = "static",
      top_down = true,
    })
    vim.notify = require("notify")

    require("telescope").load_extension("notify")
  end,
}

return M
