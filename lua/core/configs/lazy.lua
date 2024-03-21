local icons = require("core.configs.icons")

local M = {
  defaults = { lazy = true },

  install = { colorscheme = { "catppuccin" } },

  ui = {
    size = {
      width = 0.8,
      height = 0.8,
    },
    icons = {
      ft = icons.ui.File,
      lazy = icons.ui.Pending,
      loaded = icons.ui.Checked,
      not_loaded = icons.ui.Unchecked,
    },
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}

return M
