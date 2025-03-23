local M = {
  "lukas-reineke/virt-column.nvim",
  event = "VimEnter",
  config = function()
    require("virt-column").setup({
      char = "▕",
      highlight = "VirtColumn",
      virtcolumn = "80,120",
      exclude = {
        filetypes = {
          "markdown",
        },
      },
    })
  end,
}

return M
