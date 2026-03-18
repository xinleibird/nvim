---@module "lazy"
---@type LazySpec
local M = {
  "xinleibird/switch-abc.nvim",
  lazy = false,
  build = "make",
  enabled = function()
    return require("utils").detect_os() == "macos"
  end,
  config = function()
    require("switch-abc").setup({
      target_id = "com.apple.keylayout.ABC",
    })
  end,
}

return M
