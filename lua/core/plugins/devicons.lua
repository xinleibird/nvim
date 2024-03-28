local M = {
  "nvim-tree/nvim-web-devicons",
  config = function()
    require("nvim-web-devicons").setup({
      override = require("core.configs.icons").devicons,
    })
  end,
}

return M
