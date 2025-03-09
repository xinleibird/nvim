local M = {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
  dependencies = "neovim/nvim-lspconfig",

  init = function()
    vim.g.mason_ensure_installed = {
      -- lua stuff
      "lua-language-server",
      "stylua",

      -- web dev stuff
      "css-lsp",
      "deno",
      "eslint-lsp",
      "emmet-language-server",
      "html-lsp",
      "prettier",
      "typescript-language-server",
      "vtsls",

      -- browser debug
      "firefox-debug-adapter",
      "js-debug-adapter",

      -- c/cpp stuff
      "clangd",
      "clang-format",

      -- shell stuff
      "bash-language-server",
      "shfmt",
      "shellcheck",

      -- go stuff
      "gopls",
      "goimports",

      -- rust stuff
      "rust-analyzer",
      "codelldb",

      -- vim stuff
      "vim-language-server",

      -- json / yaml
      "json-lsp",
      "yaml-language-server",
    }
    -- custom cmd to install all mason binaries listed
    vim.api.nvim_create_user_command("MasonInstallAll", function()
      if vim.g.ensure_installed and #vim.g.ensure_installed > 0 then
        vim.cmd("MasonInstall " .. table.concat(vim.g.ensure_installed, " "))
      end
    end, {})

    vim.g.mason_binaries_list = vim.g.ensure_installed
  end,

  opts = function()
    local icons = require("configs.icons")

    return {
      ensure_installed = vim.g.mason_ensure_installed,

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
  end,

  config = function(_, opts)
    require("mason").setup(opts)
  end,
}

return M
