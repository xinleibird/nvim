vim.filetype.add({
  pattern = {
    [".*/themes/catppuccin-.*"] = "txt",
  },
})

local M = {
  {
    "davidmh/mdx.nvim",
    config = true,
    event = "BufRead",
    ft = { "mdx", "markdown.mdx" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}

return M
