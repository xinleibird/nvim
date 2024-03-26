local M = {
  "saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  config = function()
    require("crates").setup({})
  end,
}

return M
