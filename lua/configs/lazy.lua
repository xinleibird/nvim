-- Bootstrap lazy.nvim
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  defaults = {
    lazy = true,
  },
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  install = {
    missing = true,
    colorscheme = { "catppuccin" },
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
  -- options
  opts = {
    rocks = {
      enabled = false,
      hererocks = false,
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        -- "2html_plugin",
        -- "tohtml",
        -- "getscript",
        -- "getscriptPlugin",
        -- "gzip",
        -- "logipat",
        -- "netrw",
        -- "netrwPlugin",
        -- "netrwSettings",
        -- "netrwFileHandlers",
        -- "matchit",
        -- "tar",
        -- "tarPlugin",
        -- "rrhelper",
        -- "spellfile_plugin",
        -- "vimball",
        -- "vimballPlugin",
        -- "zip",
        -- "zipPlugin",
        -- "tutor",
        -- "rplugin",
        -- "syntax",
        -- "synmenu",
        -- "optwin",
        -- "compiler",
        -- "bugreport",
        -- "ftplugin",
      },
    },
  },
})
