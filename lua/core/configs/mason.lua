local icons = require("core.configs.icons")
local M = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "deno",
    "eslint-lsp",
    "html-lsp",
    "prettier",
    "typescript-language-server",

    -- browser debug
    "firefox-debug-adapter",
    "js-debug-adapter",

    -- c/cpp stuff
    "clangd",
    "clang-format",

    -- shell stuff
    "shfmt",
    "bash-language-server",

    -- go stuff
    "gopls",
    "goimports",

    -- vim stuff
    "vim-language-server",

    -- json / yaml
    "json-lsp",
    "yaml-language-server",
  },

  PATH = "skip",

  ui = {
    width = 0.8,
    height = 0.8,
    icons = {
      package_pending = icons.ui.Pending,
      package_installed = icons.ui.Checked,
      package_uninstalled = icons.ui.Unchecked,
    },

    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },

  max_concurrent_installers = 10,
}

return M
