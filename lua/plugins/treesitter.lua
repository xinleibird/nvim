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

    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = "*",
    --   callback = function(ev)
    --     local ft = ev.match
    --     local ignore_prefixes =
    --       { "snacks_", "dap-", "dapui_", "fidget", "Outline", "blink-", "lazy", "mason", "bigfile", "flash" }
    --
    --     for _, prefix in ipairs(ignore_prefixes) do
    --       if ft:find(prefix, 1, true) then
    --         return
    --       end
    --     end
    --
    --     vim.treesitter.start()
    --     vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    --     vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    --     vim.wo[0][0].foldmethod = "expr"
    --   end,
    -- })

    local function get_files_in_directory(directory)
      local pattern = directory .. "/*.lua"
      local files_str = vim.fn.glob(pattern)

      if files_str == "" then
        return {}
      end

      local files_list = vim.split(files_str, "\n", { plain = true })

      local absolute_files = {}
      for _, file_path in ipairs(files_list) do
        table.insert(absolute_files, vim.fn.fnamemodify(file_path, ":p"))
      end

      return absolute_files
    end

    local function gen_pattern()
      local lsp_config_dir = vim.fn.stdpath("config") .. "/lsp"
      local lsp_config_list = get_files_in_directory(lsp_config_dir)

      local ft_set = {}

      for _, lsp_config in ipairs(lsp_config_list) do
        local filetypes = dofile(lsp_config).filetypes

        for _, ft in ipairs(filetypes) do
          ft_set[ft] = true
        end
      end

      local pattern = {}
      for ft, _ in pairs(ft_set) do
        table.insert(pattern, ft)
      end

      return pattern
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = gen_pattern(),
      callback = function()
        vim.treesitter.start() -- enable treesitter highlight
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
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
