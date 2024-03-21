-- enable vim-plugin just for VSCode-Neovim
if vim.g.vscode then
  vim.cmd.runtime("plug.vim")
  vim.cmd.runtime("vscode.vim")
  return -- in vscode stop load
end

-- within Neovide
if vim.g.neovide then
  require("neovide")
end

-- mapleader
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("core.configs.lazy")

-- load plugins
require("lazy").setup({
  {
    lazy = false,
    import = "core.plugins",
  },

  {
    import = "custom.plugins",
  },
}, lazy_config)

-- load options
require("options")
-- load autocmds
require("autocmds")
-- schedule next tick to load mappings
vim.schedule(function()
  require("mappings")
end)
