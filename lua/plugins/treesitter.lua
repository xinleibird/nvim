local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      highlight = {
        enable = true,
        use_languagetree = true,
      },

      ensure_installed = {
        "bash",
        "c",
        "css",
        "html",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "tsx",
        "typescript",
        "vim",
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
