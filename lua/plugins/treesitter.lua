local M = {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  init = function()
    local ensure_list = {
      "bash",
      "c",
      "css",
      "gitignore",
      "html",
      "javascript",
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
    }
    vim.api.nvim_create_user_command("TSInstallEnsured", function()
      require("nvim-treesitter").install(ensure_list):wait(600000)
    end, {})

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(ev)
        local ft = ev.match
        local ignore_prefixes = { "snacks_", "dap-", "dapui_", "fidget", "Outline" }

        for _, prefix in ipairs(ignore_prefixes) do
          if ft:find(prefix, 1, true) then
            return
          end
        end

        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
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
