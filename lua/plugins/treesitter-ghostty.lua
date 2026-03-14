---@module "lazy"
---@type LazySpec
local M = {
  "bezhermoso/tree-sitter-ghostty",
  build = "make nvim_install",
  lazy = false,
}

return M
