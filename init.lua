-- enable vim-plugin just for VSCode-Neovim
if vim.g.vscode then
  vim.cmd.runtime("./plug.vim")
  vim.cmd.runtime("./vscode.vim")
  return -- in vscode stop load
end

-- within Neovide
if vim.g.neovide then
  require("configs.neovide")
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
    import = "plugins",
  },
}, require("configs.lazy"))

-- load options
require("configs.options")
-- load autocmds
require("configs.autocmds")
-- schedule next tick to load mappings
vim.schedule(function()
  require("configs.mappings")
end)
