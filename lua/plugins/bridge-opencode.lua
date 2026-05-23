---@module "lazy"
---@type LazySpec
local M = {
  "xinleibird/bridge.opencode",
  priority = 1000,
  lazy = false,
  build = function(plugin)
    local plugin_dir = plugin.dir or (vim.fn.stdpath("data") .. "/lazy/bridge.opencode")
    local opencode_home = vim.fn.expand("~/.config/opencode")

    vim.fn.mkdir(opencode_home .. "/bin", "p")
    vim.fn.mkdir(opencode_home .. "/plugins", "p")

    vim.fn.system({ "cargo", "build", "--release", "--manifest-path", plugin_dir .. "/Cargo.toml" })
    vim.fn.system({ "cp", plugin_dir .. "/target/release/bridge", plugin_dir .. "/bin" })

    local bin_target = opencode_home .. "/bin/bridge"
    local plugin_target = opencode_home .. "/plugins/bridge.ts"
    vim.fn.delete(bin_target)
    vim.fn.delete(plugin_target)

    vim.fn.system({ "ln", "-sf", plugin_dir .. "/bin/bridge", bin_target })
    vim.fn.system({ "ln", "-sf", plugin_dir .. "/opencode/bridge.ts", plugin_target })
  end,
}

return M
