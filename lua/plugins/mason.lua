local M = {
  "williamboman/mason.nvim",
  event = "VimEnter",
  init = function()
    local mason_ensure_installed = {
      -- lua stuff
      "lua-language-server",
      "stylua",

      -- web dev stuff
      "css-lsp",
      "eslint-lsp",
      "html-lsp",
      "htmlhint",
      "prettier",
      "svelte-language-server",
      "typescript-language-server",
      "vtsls",
      "vue-language-server",

      -- browser debug
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
    vim.api.nvim_create_user_command("MasonInstallEnsured", function()
      local mason_already_installed = require("mason-registry").get_installed_package_names()

      local already_set = {}
      for _, package_name in pairs(mason_already_installed) do
        already_set[package_name] = true
      end

      local will_install = {}
      for _, package_name in ipairs(mason_ensure_installed) do
        if not already_set[package_name] then
          table.insert(will_install, package_name)
        end
      end

      if #will_install > 0 then
        vim.cmd("MasonInstall " .. table.concat(will_install, " "))
      else
        vim.api.nvim_echo({ { "All ensure mason packages have been installed", "MoreMsg" } }, true, {})
      end
    end, {})
  end,
  opts = function()
    local icons = require("configs.icons")
    return {
      ---@type '"prepend"' | '"append"' | '"skip"'
      PATH = "prepend",

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
