local M = {
  "rcarriga/nvim-notify",
  event = "UIEnter",
  priority = 1000,
  config = function()
    require("notify").setup({
      render = "default",
      timeout = 2000,
      stages = "static",
      top_down = true,
      merge_duplicates = true,
    })
    vim.notify = require("notify")

    require("telescope").load_extension("notify")
  end,
}

return M
