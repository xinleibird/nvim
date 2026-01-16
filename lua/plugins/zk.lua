local M = {
  "zk-org/zk-nvim",
  lazy = false,
  config = function()
    require("zk").setup({
      -- See Setup section below
      picker = "snacks_picker",
    })
  end,
}

return M
