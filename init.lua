-- enable vim-plugin just for VSCode-Neovim
if vim.g.vscode then
  vim.cmd.runtime("plug.vim")
  vim.cmd.runtime("vscode.vim")
  return -- in vscode stop load
end

-- within Neovide
if vim.g.neovide then
  require("local.neovide")
end

-- MUST set mapleader **FEFORE** lazy load
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- load plugins
require("lazy").setup({
  {
    import = "core.plugins",
  },
}, require("core.configs.lazy"))

-- load options
require("local.options")
-- load autocmds
require("local.autocmds")
-- schedule next tick to load mappings
vim.schedule(function()
  require("local.mappings")
end)
