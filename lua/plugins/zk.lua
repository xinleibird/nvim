local M = {
  "zk-org/zk-nvim",
  lazy = false,
  config = function()
    require("zk").setup({
      picker = "snacks_picker",
      picker_options = {
        snacks_picker = {
          layout = {
            preset = "default",
          },
        },
      },
    })
  end,
}

return M
