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

local function init()
  -- custom cmd to install all mason binaries listed
  vim.api.nvim_create_user_command("MasonInstallAll", function()
    if M.ensure_installed and #M.ensure_installed > 0 then
      vim.cmd("MasonInstall " .. table.concat(M.ensure_installed, " "))
    end
  end, {})

  vim.g.mason_binaries_list = M.ensure_installed

  return M
end

return init()
