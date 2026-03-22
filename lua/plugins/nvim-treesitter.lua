---@module "lazy"
---@type LazySpec
local M = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
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
      end, { desc = "Outer Function" })
      vim.keymap.set({ "x", "o" }, "im", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end, { desc = "Inner Function" })
      vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
      end, { desc = "Outer Class" })
      vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
      end, { desc = "Inner Class" })
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ "x", "o" }, "as", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
      end, { desc = "Outer Scope" })
      vim.keymap.set({ "x", "o" }, "is", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
      end, { desc = "Inner Scope" })
      -- m function
      -- c class
      -- s scope
      -- i object
    end,
  },
  init = function()
    vim.api.nvim_create_user_command("TSStart", function()
      vim.treesitter.start(0)
    end, { desc = "Start treesitter" })
    vim.api.nvim_create_user_command("TSStop", function()
      vim.treesitter.stop(0)
    end, { desc = "Stop treesitter" })
    vim.api.nvim_create_user_command("TSRestart", function()
      vim.treesitter.stop(0)
      vim.treesitter.start(0)
    end, { desc = "Restart treesitter" })
  end,

  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    local ensure_languages = {
      "bash",
      "c",
      "css",
      "gitignore",
      "html",
      "http",
      "javascript",
      "jsdoc",
      "json",
      "latex",
      "lua",
      "make",
      "markdown",
      "regex",
      "rust",
      "scss",
      "svelte",
      "swift",
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
      require("nvim-treesitter").install(ensure_languages):wait(600000)
    end, { desc = "Install all ensured treesitter parsers" })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter_setup", { clear = true }),
      callback = function(e)
        local bufnr = e.buf
        local filetype = e.match

        -- you need some mechanism to avoid running on buffers that do not
        -- correspond to a language (like oil.nvim buffers), this implementation
        -- checks if a parser exists for the current language
        local language = vim.treesitter.language.get_lang(filetype) or filetype

        local parser = vim.treesitter.language.add(language)
        if parser then
          vim.treesitter.start(bufnr, language)
        end

        local folds = vim.treesitter.query.get(language, "folds")
        if folds then
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end

        local indents = vim.treesitter.query.get(language, "indents")
        if indents then
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}

return M
