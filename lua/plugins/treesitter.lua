local M = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      vim.g.no_plugin_maps = true
      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
    end,
    config = function()
      vim.keymap.set({ "x", "o" }, "am", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "im", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
      end)
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ "x", "o" }, "as", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
      end)
      vim.keymap.set({ "x", "o" }, "is", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
      end)
    end,
  },
  init = function()
    local ensure_list = {
      "bash",
      "c",
      "css",
      "gitignore",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "latex",
      "lua",
      "markdown",
      "regex",
      "rust",
      "scss",
      "svelte",
      "toml",
      "tsx",
      "typescript",
      "typst",
      "vim",
      "vue",
      "yaml",
      "zsh",
    }
    vim.api.nvim_create_user_command("TSInstallEnsured", function()
      require("nvim-treesitter").install(ensure_list):wait(600000)
    end, { desc = "Install all ensured treesitter parsers" })

    vim.api.nvim_create_user_command("TSStart", function()
      vim.treesitter.start(0)
    end, { desc = "Start treesitter for current buffer" })
    vim.api.nvim_create_user_command("TSStop", function()
      vim.treesitter.stop(0)
    end, { desc = "Stop treesitter for current buffer" })
    vim.api.nvim_create_user_command("TSRestart", function()
      vim.treesitter.stop(0)
      vim.treesitter.start(0)
    end, { desc = "Restart treesitter for current buffer" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      group = vim.api.nvim_create_augroup("user_treesitter_init", { clear = true }),
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local parser = vim.treesitter.get_parser(bufnr, nil, { error = false })
        if parser then
          vim.treesitter.start(bufnr)
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,

  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })
  end,
}

return M
