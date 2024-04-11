local M = {
  "nvim-tree/nvim-web-devicons",
  config = function()
    require("nvim-web-devicons").setup({
      override = require("configs.icons").devicons,
    })
  end,
}

return M
