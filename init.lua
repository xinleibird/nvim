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

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- MUST set mapleader **FEFORE** lazy load
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- load plugins
require("lazy").setup({
  spec = {
    {
      import = "plugins",
    },
  },
  opts = {
    import = "configs.lazy",
  },
})

-- load options
require("configs.options")
-- load autocmds
require("configs.autocmds")
-- schedule next tick to load mappings
vim.schedule(function()
  require("configs.mappings")
end)
