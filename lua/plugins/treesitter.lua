local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("nvim-treesitter.configs").setup({
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,
      },

      ensure_installed = {
        "bash",
        "c",
        "css",
        "gitignore",
        "html",
        "javascript",
        "json",
        "jsonc",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "norg",
        "query",
        "regex",
        "scss",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
      },
      auto_install = true,

      indent = {
        enable = true,
        -- disable = {
        --   "python"
        -- },
      },
    })
  end,
}

return M
