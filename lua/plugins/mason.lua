local M = {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
  init = function()
    vim.g.mason_ensure_installed = {
      -- lua stuff
      "lua-language-server",
      "stylua",

      -- web dev stuff
      "css-lsp",
      "eslint-lsp",
      "emmet-language-server",
      "html-lsp",
      "htmlhint",
      "prettier",
      "typescript-language-server",
      "vtsls",

      -- browser debug
      "firefox-debug-adapter",
      "js-debug-adapter",

      -- shell stuff
      "bash-language-server",
      "shfmt",
      "shellcheck",

      -- rust stuff
      "rust-analyzer",
      "codelldb",

      -- vim stuff
      "vim-language-server",

      -- json / yaml
      "json-lsp",
      "yaml-language-server",

      -- markdown
      "marksman",
    }
    -- custom cmd to install all mason binaries listed
    vim.api.nvim_create_user_command("MasonInstallAll", function()
      if vim.g.mason_ensure_installed and #vim.g.mason_ensure_installed > 0 then
        vim.cmd("MasonInstall " .. table.concat(vim.g.mason_ensure_installed, " "))
      end
    end, {})
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
      },

      max_concurrent_installers = 10,
    }
  end,

  config = function(_, opts)
    require("mason").setup(opts)
  end,
}

return M
