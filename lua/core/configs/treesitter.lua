local M = {
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
}

return M
